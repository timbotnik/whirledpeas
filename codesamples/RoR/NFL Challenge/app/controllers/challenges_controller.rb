class ChallengesController < ApplicationController
  layout "challenges"
  before_filter :validateChallenge

  def validateChallenge
    begin 
      @challenge   = Challenge.find_with_includes(params[:id]).first
      @challenge_t = ChallengeTemplate.get_from_config(@challenge['template_id'])

      if @current_user.id != nil
        @mypick = ChallengeResponse.find_by_challenge_id_and_user_id(@challenge.id,@current_user.id) || ChallengeResponse.new()
      else
        @mypick = ChallengeResponse.new()
      end
    rescue => e
      redirect_to :controller => 'welcome', :action => "index"
    end

    @allowed = false
    
    if (!@challenge['public'])
      @challenge.challenge_responses.each do |response|
        @allowed = true if response.user_id == @current_user.id
      end
    else
      @allowed = true
    end
  end
  
  def index
    @challenge = self.format_expression(@challenge)
    @challenge.set_winner

    case @challenge.challenge_type.to_s
    when 'custom'
      @picks = JSON.load(@challenge.picks)
    when 'game'
      @game = Game.includes(:home_team,:away_team).find_by_game_id(@challenge.game_id)
    when 'team'
      @teams = Team.all
    when 'player'
      case @challenge.challenge_subtype
      when 'any'
        if (!@challenge.featured)
          @p1_thumb = player_thumb(@challenge.player1)
          @team1    = Team.find_by_team_id(@challenge.player1.team_id)
        end
        @teams    = Team.all
      else
        @p1_thumb = player_thumb(@challenge.player1)
        @p2_thumb = player_thumb(@challenge.player2)
        @team1    = Team.find_by_team_id(@challenge.player1.team_id)
        @team2    = Team.find_by_team_id(@challenge.player2.team_id)
      end

      if !@mypick.status.nil? and @mypick['status'] != 'pending'
        @mypick.player     = Player.find_by_player_id(@mypick.response)
        @mypick['team_info']  = Team.find_by_team_id(@mypick.player.team_id)
        @mypick['thumb']      = player_thumb(@mypick.player)
      end
    else
      redirect_to :controller => 'welcome', :action => 'index'
    end
  end
  
  def step2_pvp
    if (@challenge.user_id != @current_user.id)
      redirect_to :action => 'index', :id => @challenge.id
      return
    end
    
  
    if (@challenge.player1_id != nil)
      @p1_thumb = player_thumb(@challenge.player1)
      @team1    = Team.find_by_team_id(@challenge.player1.team_id)
    end

    if (@challenge.player2_id != nil)
      @p2_thumb = player_thumb(@challenge.player2)
      @team2    = Team.find_by_team_id(@challenge.player2.team_id)
    end

    @challenge['challenge_expression']["{PLAYER}"] = 
      @challenge.player1['first']+' '+
      @challenge.player1['last']+' OR '+
      @challenge.player2['first']+' '+
      @challenge.player2['last']
  end

  private

  def player_thumb player
    player = player.player_id
    "#{player[0]}/#{player[1]}/#{player[2]}/#{player}.jpg"
  end
end