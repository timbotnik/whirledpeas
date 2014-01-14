class GameStat < ActiveRecord::Base  
  validates :game_id,  :presence => true, :numericality => true
	validates :team_id,  :presence => true, :numericality => true

  belongs_to :game, :class_name => 'Game', :foreign_key => 'game_id', :primary_key => 'game_id'
  belongs_to :team, :class_name => 'Team', :foreign_key => 'team_id', :primary_key => 'team_id'
  
  def self.list
    return Game.find(:all, :include => [ :team ], :order => 'starts_at')
  end
  
  def self.import(obj, game_week)
    if (!obj)
      raise 'Could not import blank game stats'
    end
    
    # Convert camelcase to underscore
    data = { 
      'game_id' => obj['gameId'],
      'team_id' => obj['entityId'],
      'week_id' => game_week.week_id   
    }
    # Convert white space to underscore
    obj['scores'].each do |key, value|
      score = key.gsub(/\s/, '_')
      data[score] = value
    end
    
    team = Team.find_by_team_id(data['team_id'])
    if (!team)
      raise 'Could not import game stats for team id =' + data['team_id']
    end
    
    #Create or Update
    game_stats = GameStat.find_by_team_id_and_game_id(data['team_id'], data['game_id']) || 
      GameStat.new(:game_id => data['game_id'])
    game_stats.update_attributes!(data)
  
  rescue => e
    logger.error(e.message)
  end
  
end