class Player < ActiveRecord::Base
	validates :first,  :presence => true
  validates :last, :presence => true
  validates :position, :presence => true
  validates :number, :presence => true, :numericality => true
  validates :team_id, :presence => true, :numericality => true
  
  has_many :challenges
  has_many :player_stats
  belongs_to :team, :class_name => 'Team', :foreign_key => 'team_id', :primary_key => 'team_id'
  
  def self.search(post)
    Player.where("team_id = ? AND position IN (?)", post['team_id'], post['position'])
  end
  
  def self.list
    return Player.find_by_sql(
      'SELECT p.*,
       (SELECT teams.name FROM teams WHERE team_id = p.team_id LIMIT 1) as team_name
       FROM players p
       ORDER BY p.player_id'
    )
  end
  
  def self.import(obj)
    # Convert camelcase to underscore
    data = { 
      "player_id" => obj['id'],
      "status" => obj['active'],
      "first" => obj['firstName'],
      "last" => obj['lastName'],
      "position" => obj['position'],
      "number" => obj['number'],
      "team_id" => obj['teamId']
    }
    #Create or Update
    player = Player.find_by_player_id(data['player_id']) || Player.new(:player_id => data['player_id'])
    player.update_attributes!(data)
  end
      
end
