class Team < ActiveRecord::Base
	validates :abbr,  :presence => true
  validates :city, :presence => true
  validates :name, :presence => true
  validates :stadium, :presence => true
  
  has_many :games
  has_many :players
  
  def self.import(obj)
    # Convert camelcase to underscore
    data = { 
      "team_id" => obj['id'],
      "name" => obj['nickname'],
      "city" => obj['cityState'],
      "abbr" => obj['abbreviation'],
      "stadium" => obj['stadiumName']
    }
    #Create or Update
    team = Team.find_by_team_id(data['team_id']) || Team.new(:team_id => data['team_id'])
    team.update_attributes!(data)
  end
      
  def find_games_for_week(game_week)
    Game.list_for_week_and_team(game_week, team_id)
  end
end
