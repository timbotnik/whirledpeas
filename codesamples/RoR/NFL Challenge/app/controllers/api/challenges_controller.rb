class Api::ChallengesController < Api::ApiController
  require 'open-uri'
  require 'pp'
  before_filter :validate_api_role, :only => [:create_custom]
  
  def index
    @challenges = Challenge.all
    response = ApiSuccess.new(@challenges)
    render :json => response
  end

  def show
    @challenge = Challenge.includes(:challenge_responses).find(params[:id])
    response = ApiSuccess.new(@challenge)
    render :json => response
  end
  
  def create_custom
    @challenge_t = ChallengeTemplate.get_from_config('custom_challenge')
    @game = Game.find_by_game_id(params[:challenge][:game_id])
    @challenge = Challenge.new({
      :template_id => @challenge_t['template_id'],
      :stakes => params[:challenge][:stakes],
      :challenge_expression => params[:challenge][:question],
      :display_text => params[:challenge][:question],
      :challenge_type => @challenge_t['challenge_type'],
      :challenge_subtype => @challenge_t['challenge_subtype'],
      :sponsor_id => params[:challenge][:sponsor_id],
      :picks => params[:challenge][:picks],
      :public => true,
      :user_id => @current_user.id,
      :featured => true,
      :status => 'active',
      :closes_at => @game.starts_at - Challenge.closing_time_offset
    })
    @challenge.save!
    response = ApiSuccess.new(@challenge)
    render :json => response
  end
  
  def create_game
    @challenge_t = ChallengeTemplate.get_from_config(params[:challenge][:template_id])
    challenge_expression = (params[:challenge][:challenge_expression] != nil) ? params[:challenge][:challenge_expression] : @challenge_t['template_expression']
    display_text = (params[:challenge][:challenge_expression] != nil) ? params[:challenge][:challenge_expression] : @challenge_t['display_text']
    @game = Game.find_by_game_id(params[:challenge][:game_id])
    @challenge = Challenge.new({
      :template_id => @challenge_t['template_id'],
      :stakes => params[:challenge][:stakes],
      :challenge_expression => challenge_expression,
      :display_text => display_text,
      :challenge_type => @challenge_t['challenge_type'],
      :challenge_subtype => @challenge_t['challenge_subtype'],
      :sponsor_id => params[:challenge][:sponsor_id],
      :game_id => params[:challenge][:game_id],
      :picks => @challenge_t['picks'],
      :public => params[:challenge][:public],
      :user_id => @current_user.id,
      :featured => params[:challenge][:featured],
      :status => 'active',
      :closes_at => @game.starts_at - Challenge.closing_time_offset
    })
    @challenge.save!
    if (params[:challenge][:my_pick] != nil)
      data = { 
        'user_id' => @current_user.id,
        'response' => params[:challenge][:my_pick],
        'challenge_id' => @challenge.id,
        'status' => 'responded'
      }
      @challenge_response = ChallengeResponse.new(data)
      @challenge_response.save!
    end
    response = ApiSuccess.new(@challenge)
    render :json => response
  end
  
  def create_team
    @challenge_t = ChallengeTemplate.get_from_config(params[:challenge][:template_id])
    challenge_expression = (params[:challenge][:challenge_expression] != nil) ? params[:challenge][:challenge_expression] : @challenge_t['template_expression']
    display_text = (params[:challenge][:challenge_expression] != nil) ? params[:challenge][:challenge_expression] : @challenge_t['display_text']
    @team = Team.find_by_team_id(params[:challenge][:team_id])
    @game = @team.find_games_for_week(GameWeek.current)[0]
    @challenge = Challenge.new({
      :template_id => @challenge_t['template_id'],
      :stakes => params[:challenge][:stakes],
      :challenge_expression => challenge_expression,
      :display_text => display_text,
      :challenge_type => @challenge_t['challenge_type'],
      :challenge_subtype => params[:challenge][:challenge_subtype] || @challenge_t['challenge_subtype'],
      :sponsor_id => params[:challenge][:sponsor_id],
      :picks => @challenge_t['picks'],
      :user_id => @current_user.id,
      :public => params[:challenge][:public],
      :featured => params[:challenge][:featured],
      :status => 'active',
      :closes_at => @game.starts_at - Challenge.closing_time_offset
    })
    @challenge.save!
    if (params[:challenge][:my_pick] != nil)
      data = { 
          'user_id' => @current_user.id,
          'response' => params[:challenge][:my_pick],
          'challenge_id' => @challenge.id,
          'status' => 'responded'
        }
      @challenge_response = ChallengeResponse.new(data)
      @challenge_response.save!
    end
    response = ApiSuccess.new(@challenge)
    render :json => response
  end
  
  def create_player
    @challenge_t = ChallengeTemplate.get_from_config(params[:challenge][:template_id])
    challenge_expression = (params[:challenge][:challenge_expression] != nil) ? params[:challenge][:challenge_expression] : @challenge_t['template_expression']
    @challenge = Challenge.new({
      :template_id => @challenge_t['template_id'],
      :stakes => params[:challenge][:stakes],
      :challenge_expression => challenge_expression,
      :display_text => @challenge_t['display_text'],
      :challenge_type => @challenge_t['challenge_type'],
      :challenge_subtype => params[:challenge][:challenge_subtype] || @challenge_t['challenge_subtype'],
      :sponsor_id => params[:challenge][:sponsor_id],
      :player1_id => params[:challenge][:player1_id],
      :player2_id => params[:challenge][:player2_id],
      :player_filter => @challenge_t['player_filter'],
      :picks => @challenge_t['picks'],
      :user_id => @current_user.id,
      :public => params[:challenge][:public],
      :featured => params[:challenge][:featured],
      :status => 'active',
      :closes_at => Time.new
    })
    @challenge.save!
    if (@challenge.challenge_subtype == 'any')
      if (params[:challenge][:my_pick] != nil)
        data = { 
          'user_id' => @current_user.id,
          'response' => params[:challenge][:player1_id],
          'challenge_id' => @challenge.id,
          'status' => 'responded'
        }
        @challenge_response = ChallengeResponse.new(data)
        @challenge_response.save!
      end
    end
    response = ApiSuccess.new(@challenge)
    render :json => response
  end
  
  def update
    @challenge = Challenge.find(params[:id])
    @challenge.update_attributes!(params[:challenge])
    response = ApiSuccess.new(@challenge)
    render :json => response
  end
  
  def respond
    @challenge = Challenge.find(params[:data][:challenge_id])
    data = params[:data]
    data['user_id'] = @current_user.id
    @challenge_response = ChallengeResponse.find_by_challenge_id_and_user_id(@challenge.id,@current_user.id) || ChallengeResponse.new(data)
    @challenge_response.update_attributes!(data)
    response = ApiSuccess.new(@challenge_response)
    render :json => response
  end
  
  def invite
    user = User.find_by_fb_number(params[:data][:fb_number]) || User.new(params[:data][:fb_number]);
    user.update_attributes!(params[:data][:fb_number])
    @challenge = Challenge.find(params[:id])
    data = {
      'user_id' => user.id,
      'status' => 'pending',
      'request_id' => params[:data][:request_id],
      'challenge_id' => @challenge.id,
      'response' => 'pending'
    }
    @challenge_response = ChallengeResponse.new(data)
    @challenge_response.save!
    response = ApiSuccess.new(@challenge_response)
    render :json => response
    
  end

  def details
    @challenge = Challenge.includes(:challenge_responses).find(params[:id])
    response = ApiSuccess.new(@challenge)
    render :json => response
  end
  
end
