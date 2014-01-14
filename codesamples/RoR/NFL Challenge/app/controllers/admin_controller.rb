class AdminController < ApplicationController
  layout "admin"
  before_filter :preload
  before_filter :authenticate
  #before_filter :validate_role, :except => :prohibited

  require 'open-uri'
  require 'pp'
  
  def prohibited
  end
  
  def index
    @users = User.all
  end
  
  def teams
    @teams = Team.all
  end
  
  def games
    @games = Game.list
  end
  
  def players
    @players = Player.list
  end
  
  def sponsors
    @sponsors = Sponsor.all
  end
  
  def stats
    @game_stats   = GameStat.all
    @player_stats = PlayerStat.all
  end
  
  def challenges
    @sponsors   = Sponsor.all
    @games      = Game.list_for_week(GameWeek.new(Time.parse(NflConfig.get('season', 'starts_at'))))
    @challenges = Challenge.admin
  end

  def playerChallenge
    retrieve_challenges 'player'
  end
  
  def gameChallenge
   retrieve_challenges 'game'
  end
  
  def teamChallenge
    retrieve_challenges 'team'
  end
  
  def update_scores
    ScoreKeeper.update_scores(GameWeek.current)
    redirect_to :action => "challenges"
  end
  
  def import_teams
    StatsImporter.import_teams
    redirect_to :action=> "teams"
  end
  
  def import_games
    StatsImporter.import_games
    redirect_to :action => "games"
  end
  
  def import_players
    StatsImporter.import_players
    redirect_to :action=> "players"
  end
  
  def import_stats
    StatsImporter.import_stats(GameWeek.current)
    redirect_to :action=> "stats"
  end

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'bloomberg' && password == '9e6Edr$w'
    end
  end
end