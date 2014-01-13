class ScoreKeeper
  @@instance = nil
  
  def self.the_instance
    if (@@instance == nil)
      @@instance = ScoreKeeper.new
    end
    return @@instance
  end
  
  def self.close_active_challenges
    Challenge.find_each(:conditions => ['closes_at < :current_time AND status = :status', 
      {:current_time => GameWeek.current_time, :status => 'active'}]) do |challenge|
      begin
        challenge.status = :closed
        challenge.save!
      rescue
        next
      end
    end
  end
  
  def self.update_statistical_scores(game_week)
    records_updated = 0
    Challenge.find_each(:conditions => 
      ['status = :status AND closes_at BETWEEN :week_starts_at and :week_ends_at',
      {:status => 'closed', :week_starts_at => game_week.starts_at, :week_ends_at => game_week.ends_at}]) do |challenge|
      begin
        challenge.status = :processing
        challenge.save!
        
        #call the corresponding class method for each template_id
        self.the_instance.send(challenge.template_id, challenge, game_week)
        
        challenge.status = :processed
        challenge.save!
        records_updated += 1
      rescue
        challenge.status = :error
        challenge.save!
      end
    end
    return records_updated
  end

  def self.update_custom_scores
    records_updated = 0
    Challenge.find_each(:conditions => 
      ['status = :status AND template_id = :custom_template_id',
      {:status => 'closed', :custom_template_id => 'custom_challenge'}]) do |challenge|
      begin
        challenge.status = :processing
        challenge.save!
        
        #call the corresponding class method for each template_id
        self.the_instance.send(challenge.template_id, challenge, game_week)
        
        challenge.status = :processed
        challenge.save!
        
        records_updated += 1
      rescue
        challenge.status = :error
        challenge.save!
      end
    end
    return records_updated
  end

  
  def self.update_scores_task
    game_week = GameWeek.previous
    records_updated = 0
    
    # check to make sure stats have been imported for the week
    if (StatsLog.find_by_week_id_and_status(game_week.week_id, 'imported') != nil)
      records_updated += self.update_statistical_scores(game_week);
    end
    
    records_updated += self.update_custom_scores
    return records_updated
  end

  private
  
  #################
  #SCORING METHODS
  #################
  
  def score_numeric_closest(challenge, without_going_over = false)
    closest_so_far = challenge.challenge_responses.first
    target = Integer(challenge.result)
    min_diff = (Integer(closest_so_far.response) - target).abs
    
    challenge.challenge_responses.all.each do |response|
      answer = Integer(response.response)
      diff = (answer - target).abs
      if (diff < min_diff && (!without_going_over || answer <= target))
        closest_so_far = response
        min_diff = diff
      end
    end
    
    closest_target = Integer(closest_so_far.response)
    challenge.challenge_responses.all.each do |response|
      response.status = Integer(response.response) == closest_target ? 'won' : 'lost'
      response.save!
    end
  end

  def score_exact_match(challenge)
    challenge.challenge_responses.all.each do |response|
      response.status = response.response == challenge.result ? 'won' : 'lost'
      response.save!
    end
  end
  
  def score_in_set(challenge)
    set = challenge.result.split(',')
    challenge.challenge_responses.all.each do |response|
      response.status = set.index(response.response) != nil ? 'won' : 'lost'
      response.save!
    end
  end
  
  
  #################
  #CUSTOM CHALLENGE
  #################
    
  def custom_challenge(challenge, game_week)
    score_exact_match(challenge)
  end
  
  
  #################
  #GAME CHALLENGES
  #################
    
  def game_turnovers(challenge, game_week)
    result = GameStat.sum(:turnovers, 
      :conditions => ['game_id = :game_id', {:game_id => challenge.game_id}])
    challenge.result = result.to_s
    challenge.save!
    score_numeric_closest(challenge)
  end

  def game_touchdowns(challenge, game_week)
    result = GameStat.sum(:touchdowns, 
      :conditions => ['game_id = :game_id', {:game_id => challenge.game_id}])
    challenge.result = result.to_s
    challenge.save!
    score_numeric_closest(challenge)
  end
  
  def game_passing_attempts(challenge, game_week)
    result = GameStat.sum(:passing_attempts, 
      :conditions => ['game_id = :game_id', {:game_id => challenge.game_id}])
    challenge.result = result.to_s
    challenge.save!
    score_numeric_closest(challenge)
  end
  
  def game_points(challenge, game_week)
    result = GameStat.sum(:points, 
      :conditions => ['game_id = :game_id', {:game_id => challenge.game_id}])
    challenge.result = result.to_s
    challenge.save!
    score_numeric_closest(challenge)
  end
  
  def game_rushing_attempts(challenge, game_week)
    result = GameStat.sum(:rushing_attempts, 
      :conditions => ['game_id = :game_id', {:game_id => challenge.game_id}])
    challenge.result = result.to_s
    challenge.save!
    score_numeric_closest(challenge)
  end

  def game_punts(challenge, game_week)
    result = GameStat.sum(:punts, 
      :conditions => ['game_id = :game_id', {:game_id => challenge.game_id}])
    challenge.result = result.to_s
    challenge.save!
    score_numeric_closest(challenge)
  end
  
  def game_winner(challenge, game_week)
    winning_team = GameStat.order('points_scored desc').where('game_id = :game_id', {:game_id => challenge.game_id}).first
    challenge.result = winning_team.team_id.to_s
    challenge.save!
    score_exact_match(challenge)
  end
  
  def game_yards(challenge, game_week)
    stats = GameStat.where('game_id = :game_id', {:game_id => challenge.game_id})
    yards = 0
    stats.each do |team_stat|
      yards += team_stat.rushing_yards + team_stat.passing_yards
    end
    challenge.result = yards.to_s
    challenge.save!
    score_exact_match(challenge)
  end


  #################
  #PLAYER CHALLENGES
  #################

  def player_completed_passes(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:completed_passes, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'completed_passes = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
    
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end

  def player_rushing_attempts(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:rushing_attempts, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'rushing_attempts = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
    
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end

  def player_catches(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:catches, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'catches = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
    
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end

  def player_yards_after_catch(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:yards_after_catch, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'yards_after_catch = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
    
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end

  def player_touchdowns(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:touchdowns, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'touchdowns = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
    
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end

  def player_passing_yards(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:passing_yards, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'passing_yards = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
    
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end

  def player_interceptions_thrown(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:interceptions_thrown, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'interceptions_thrown = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
   
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end

  def player_fumbles(challenge, game_week)
    player_ids = challenge.challenge_subtype == 'pvp' ?
        Array.new << challenge.player1_id.to_s << challenge.player2_id.to_s
      : challenge.challenge_responses.collect(&:response).uniq
    
    most = PlayerStat.maximum(:fumbles, 
      :conditions => ['week_id = :week_id AND player_id IN(:player_ids)', 
      {:week_id => game_week.week_id, :player_ids => player_ids}])
    
    winning_players = PlayerStat.where(
        'fumbles = :most AND week_id = :week_id AND player_id IN(:player_ids)', 
        {:week_id => game_week.week_id, :most => most, :player_ids => player_ids})
    
    winning_player_ids = winning_players.collect(&:player_id)
    challenge.result = winning_player_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end
  
  
  #################
  #TEAM CHALLENGES
  #################

  def team_completed_passes(challenge, game_week)
    team_ids = challenge.challenge_responses.collect(&:response).uniq
    
    most = GameStat.maximum(:completed_passes, 
      :conditions => ['week_id = :week_id AND team_id IN(:team_ids)', 
      {:week_id => game_week.week_id, :team_ids => team_ids}])
    
    winning_teams = GameStat.where(
      'completed_passes = :most AND week_id = :week_id AND team_id IN(:team_ids)', 
      {:week_id => game_week.week_id, :most => most, :team_ids => team_ids})
    
    winning_team_ids = winning_teams.collect(&:team_id)
    challenge.result = winning_team_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end
  
  def team_turnovers(challenge, game_week)
    team_ids = challenge.challenge_responses.collect(&:response).uniq
    
    most = GameStat.maximum(:turnovers, 
      :conditions => ['week_id = :week_id AND team_id IN(:team_ids)', 
      {:week_id => game_week.week_id, :team_ids => team_ids}])
    
    winning_teams = GameStat.where(
      'turnovers = :most AND week_id = :week_id AND team_id IN(:team_ids)', 
      {:week_id => game_week.week_id, :most => most, :team_ids => team_ids})
   
    winning_team_ids = winning_teams.collect(&:team_id)
    challenge.result = winning_team_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end
  
  def team_touchdowns(challenge, game_week)
    team_ids = challenge.challenge_responses.collect(&:response).uniq
    
    most = GameStat.maximum(:touchdowns, 
      :conditions => ['week_id = :week_id AND team_id IN(:team_ids)', 
      {:week_id => game_week.week_id, :team_ids => team_ids}])
    
    winning_teams = GameStat.where(
      'touchdowns = :most AND week_id = :week_id AND team_id IN(:team_ids)', 
      {:week_id => game_week.week_id, :most => most, :team_ids => team_ids})
  
    winning_team_ids = winning_teams.collect(&:team_id)
    challenge.result = winning_team_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end
  
  def team_yards(challenge, game_week)
    team_ids = challenge.challenge_responses.collect(&:response).uniq
    
    stats = GameStat.find_by_sql(['SELECT
      MAX(total_yards) as most_yards
      FROM (
        SELECT (passing_yards + rushing_yards) as total_yards
        FROM game_stats
        WHERE week_id = :week_id
        AND team_id IN(:team_ids)
        )', 
      {:week_id => game_week.week_id, :team_ids => team_ids}])
    
    most = stats[0]['most_yards']
   
    winning_teams = GameStat.where(
      '(passing_yards + rushing_yards) = :most AND week_id = :week_id AND team_id IN(:team_ids)', 
      {:week_id => game_week.week_id, :most => most, :team_ids => team_ids})
    
    winning_team_ids = winning_teams.collect(&:team_id)
    challenge.result = winning_team_ids.join(',')
    challenge.save!
    score_in_set(challenge)
  end
  
end