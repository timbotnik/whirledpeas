class Game < ActiveRecord::Base
	validates :home_team_id,  :presence => true, :numericality => true
  validates :away_team_id, :presence => true, :numericality => true
  validates :starts_at, :presence => true
  
  belongs_to :home_team, :class_name => 'Team', :foreign_key => 'home_team_id', :primary_key => 'team_id'
  belongs_to :away_team, :class_name => 'Team', :foreign_key => 'away_team_id', :primary_key => 'team_id'
  belongs_to :challenge, :class_name => 'Challenge', :foreign_key => 'game_id', :primary_key => 'game_id'
  has_many :game_stats
  has_many :challenges
  
  @@json_options = {:include => [:home_team, :away_team]}
  
  def self.list
    return Game.find(:all, :include => [ :home_team, :away_team ], :order => 'starts_at')
  end
  
  def self.list_for_week(game_week)
    return Game.includes([:home_team, :away_team]).where('starts_at > :starts_at AND starts_at < :ends_at', 
      { :starts_at => game_week.starts_at, :ends_at => game_week.ends_at }
    )
  end
  
  def self.list_for_week_and_team(game_week, team_id)
    return Game.includes([:home_team, :away_team]).where('starts_at > :starts_at AND starts_at < :ends_at AND (home_team_id = :team_id OR away_team_id = :team_id)', 
      { :starts_at => game_week.starts_at, :ends_at => game_week.ends_at, :team_id => team_id }
    )
  end
  
  def self.import(obj)
    # Convert camelcase to underscore
    game_time = Integer(obj['gameTimeEastern']) / 1000;
    starts_at = Time.at(game_time)
    data = { 
      "game_id" => obj['id'],
      "home_team_id" => obj['homeTeamId'],
      "away_team_id" => obj['awayTeamId'],
      "starts_at" => starts_at
    }
    #Create or Update
    game = Game.find_by_game_id(data['game_id']) || Game.new(:game_id => data['game_id'])
    game.update_attributes!(data)
  end
  
  def as_json (options = {})
    if (options == nil)
      options = {}
    end
    if (@@json_options != nil)
      options.merge!(@@json_options)
    end
    super(options)
  end
      
end
