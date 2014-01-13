puts 'loading challenges...'

# 1 Sponsored Game Challenge based on picks.
template = ChallengeTemplate.get_from_config('game_turnovers')
@ch_game_turnovers = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => true,
  :sponsor_id => @sponsor1.id,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 2 Sponsored Custom Challenge
template = ChallengeTemplate.get_from_config('custom_challenge')
@ch_custom = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => 'How many seconds will the first kickoff stay in the air for?',
  :display_text => 'How many seconds will the first kickoff stay in the air for?',
  :picks => "[3,4,5,6,7,8,9,10]",
  :stakes => 'winner gets a doughnut',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => true,
  :sponsor_id => @sponsor1.id,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 3 Sponsored Game challenge based on two teams.
template = ChallengeTemplate.get_from_config('game_winner')
@ch_game_winner = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => true,
  :sponsor_id => @sponsor1.id,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 4 Sponsored Team challenged based on total yards
template = ChallengeTemplate.get_from_config('team_yards')
@ch_team_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => true,
  :sponsor_id => @sponsor1.id,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 5 Sponsored PVP Player Challenge
template = ChallengeTemplate.get_from_config('player_passing_yards')
@ch_player_passing_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'pvp',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :player2_id => 'BOL517890',
  :featured => true,
  :sponsor_id => @sponsor1.id,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 6 Sponsored Single Player Challenge
@ch_player_passing_yards_sp = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'any',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :featured => true,
  :sponsor_id => @sponsor1.id,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 7 Featured Unsponsored PVP Player Challenge
template = ChallengeTemplate.get_from_config('player_touchdowns')
@ch_player_touchdowns = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'pvp',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRO662745',
  :player2_id => 'CLA796702',
  :featured => true,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 8 Featured Unsponsored Single Player Challenge
@ch_player_touchdowns_sp = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'any',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRO662745',
  :featured => true,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 9 Featured Unsponsored Game Challenge based on picks.
template = ChallengeTemplate.get_from_config('game_turnovers')
@ch_game_turnovers = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => true,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 10 Featured Unsponsored Custom Challenges
template = ChallengeTemplate.get_from_config('custom_challenge')
@ch_custom = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => 'How many seconds will the first kickoff stay in the air for?',
  :display_text => 'How many seconds will the first kickoff stay in the air for?',
  :picks => "[3,4,5,6,7,8,9,10]",
  :stakes => 'winner gets a doughnut',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => true,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 11
@ch_custom = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => 'How many total sacks will happen this weekend?',
  :display_text => 'How many total sacks will happen this weekend?',
  :picks => '[5,10,15,20]',
  :stakes => 'winner gets a pat on the back',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => true,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )
  
#########################
# Non featured Challenges
#########################

# 12 
template = ChallengeTemplate.get_from_config('game_turnovers')
@ch_game_turnovers = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 13 Custom Challenge
template = ChallengeTemplate.get_from_config('custom_challenge')
@ch_custom = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => 'How many seconds will the first kickoff stay in the air for?',
  :display_text => 'How many seconds will the first kickoff stay in the air for?',
  :picks => "[3,4,5,6,7,8,9,10]",
  :stakes => 'winner gets a doughnut',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

#14 Game challenge based on two teams.
template = ChallengeTemplate.get_from_config('game_winner')
@ch_game_winner = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 15 Team challenged based on total yards
template = ChallengeTemplate.get_from_config('team_yards')
@ch_team_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 16 PVP Player Challenge
template = ChallengeTemplate.get_from_config('player_passing_yards')
@ch_player_passing_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'pvp',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :player2_id => 'BOL517890',
  :featured => false,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 17 Single Player Challenge
@ch_player_passing_yards_sp = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'any',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :featured => false,
  :public => true,
  :status => 'active',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

########################
# CLOSED CHALLENGES
########################

# 18 Game challenge based on two teams.
template = ChallengeTemplate.get_from_config('game_winner')
@ch_game_winner = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'closed',
  :result => '920',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 19 Team challenged based on total yards
template = ChallengeTemplate.get_from_config('team_yards')
@ch_team_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'closed',
  :result => '920',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 20 PVP Player Challenge
template = ChallengeTemplate.get_from_config('player_passing_yards')
@ch_player_passing_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'pvp',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :player2_id => 'BOL517890',
  :featured => false,
  :public => true,
  :status => 'closed',
  :result => 'BRA371156',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 21 Single Player Challenge
@ch_player_passing_yards_sp = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'any',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :featured => false,
  :public => true,
  :status => 'closed',
  :result => 'BRA371156',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )


########################
# PROCESSING CHALLENGES
########################

# 22 Game challenge based on two teams.
template = ChallengeTemplate.get_from_config('game_winner')
@ch_game_winner = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'processing',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 23 Team challenged based on total yards
template = ChallengeTemplate.get_from_config('team_yards')
@ch_team_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => template['challenge_subtype'],
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :featured => false,
  :public => true,
  :status => 'processing',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 24 PVP Player Challenge
template = ChallengeTemplate.get_from_config('player_passing_yards')
@ch_player_passing_yards = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'pvp',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :player2_id => 'BOL517890',
  :featured => false,
  :public => true,
  :status => 'processing',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )

# 25 Single Player Challenge
@ch_player_passing_yards_sp = Challenge.create(
  :template_id => template['template_id'],
  :challenge_type => template['challenge_type'],
  :challenge_subtype => 'any',
  :challenge_expression => template['template_expression'],
  :display_text => template['display_text'],
  :player_filter => template['player_filter'],
  :picks => template['picks'],
  :stakes => 'Loser tweets about their loss',
  :game_id => '2010091202',
  :user_id => @user1.id,
  :player1_id => 'BRA371156',
  :featured => false,
  :public => true,
  :status => 'processing',
  :closes_at => GameWeek.previous.ends_at - 24*60*60
  )