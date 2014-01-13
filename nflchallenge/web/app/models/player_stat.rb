class PlayerStat < ActiveRecord::Base
  validates :player_id, :presence => true, :length => { :in => 1..32 }
  validates :game_id,  :presence => true, :numericality => true

  belongs_to :player, :class_name => 'Player', :foreign_key => 'player_id', :primary_key => 'player_id'
  
  def self.import(obj, game_week)
    # Convert camelcase to underscore
    if (!obj)
      raise 'Could not import blank player stats'
    end
    data = { 
      'player_id' => obj['entityId'],
      'game_id' => obj['gameId'],
      'week_id' => game_week.week_id   
    }
    # Convert white space to underscore
    obj['scores'].each do |key, value|
      score = key.gsub(/\s/, '_')
      data[score] = value
    end
    
    #Create or Update
    player = Player.find_by_player_id(data['player_id'])
    if (!player)
      raise 'Could not import player stats for ID=' + data['player_id']
    end
    player_stats = PlayerStat.find_by_player_id_and_game_id(data['player_id'], data['game_id']) || 
      PlayerStat.new(:player_id => data['player_id'])
    player_stats.update_attributes!(data)
  rescue => e
    logger.error(e.message)
  end
end