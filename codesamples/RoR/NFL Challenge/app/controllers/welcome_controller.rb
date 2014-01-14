class WelcomeController < ApplicationController
  layout "welcome", :except => :playerChallenge
  layout "custom", :only => [:playerChallenge, :gameChallenge, :teamChallenge, :challengeCurated, :history, :login]
  
  def index
    render :layout => "tab"
  end
  
  def challengeCurated
    @sponsors = Sponsor.includes([:challenges,{:challenges=>:game}]).where('challenges.status = ?','active')

    @sponsors.each do |sponsor| 
      sponsor.challenges.each do |challenge|
        challenge = self.format_expression(challenge)
      end
    end

    @challenges = Challenge.curated
    @teams = Team.all
    @challenges.each do |challenge|
      challenge = self.format_expression(challenge)
    end
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
  
  def history
    user_id = params[:id] || @current_user.fb_number
    redirect_to login_path(:next => request.fullpath) if user_id.nil? or user_id == 0

    begin
      @past_challenges = false
      @user       = User.find_by_fb_number(user_id) || User.new()
      @challenges = Challenge.history(@user['id'])
      @challenges.each do |challenge|
        challenge = self.format_expression(challenge)
        @past_challenges = true unless challenge.status == :active
        
        challenge_t = ChallengeTemplate.get_from_config(challenge['template_id'])
        
        case challenge['challenge_type']
        when 'game'
          @game = Game.includes(:home_team,:away_team).find_by_game_id(challenge.game_id)
        end
      end        
    rescue => e
      redirect_to welcome_challengeCurated_path
    end
  end
  
  def login
  end

  def logout
    self.set_cookie(nil,nil)
    redirect_to :action => 'index'
  end

end