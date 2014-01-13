class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :preload, :process_requests
  after_filter :set_p3p
  
  def set_p3p
    response.headers['P3P'] = 'CP="CAO PSA OUR"'
  end

  def preload
    @current_user = self.auto_login
  end
  
  def process_requests
    if (params[:request_ids] != nil)
      token = Facebook.token
      req = JSON.parse(Facebook.get_request(params[:request_ids],token))
      redirect_to :controller => 'challenges', :id => req['data']
      return
    end
  end
  
  def validate_role
    redirect_to admin_prohibited_path if @current_user['role'] != 'admin'
  end
  
  def auto_login
    
    #Need to get around FB?  Set to true to use Johnny Firstman
    debug = false 
    if (debug)
      return User.where(:fb_number => '100000212585579').first
    end
  
    number    = cookies['number']
    clearance = cookies['clearance']
    data      = { 'clearance' => Random.rand(999999-100000) + 100000 }
    
    if number
      existing = User.where(:fb_number => number, :clearance => clearance).first
      
      if existing
        existing.update_attributes!(data)
        self.set_cookie(number,data['clearance'])
        return existing
      end 
    end

    new_user            = User.new
    new_user.fb_number  = 0
    new_user.fb_token   = 0
    new_user.nickname   = 'Guest'
    new_user.role       = 'user'

    return new_user
  end
  
  def set_cookie(fb_number = nil,clearance = nil)
    cookies['number'] = { 
      :value    => fb_number, 
      :domain   => 'bloombergsportsfacebook.com', 
      :path     => '/',
      :expires  => 24.hours.from_now
    }
   cookies['clearance'] = { 
      :value    => clearance, 
      :domain   => 'bloombergsportsfacebook.com', 
      :path     => '/',
      :expires  => 24.hours.from_now
    }
  end

  def retrieve_challenges challenge_type
    @sponsors   = Sponsor.all
    @challenges = Array.new

    if challenge_type == 'game'
      @games = Game.list_for_week(GameWeek.new(Time.parse(NflConfig.get('season', 'starts_at'))))
    else
      @teams = Team.all
    end

    templates = YAML::load(File.open(::Rails.root.to_s + '/config/challenge_templates.yml'))
    templates.each { |key, template| @challenges.push(template) if template['challenge_type'] == challenge_type }
    return @challenges
  end
  
  def format_expression(challenge)
    challenge_t = ChallengeTemplate.get_from_config(challenge['template_id'])
    display_text = (challenge.display_text != nil) ? challenge.display_text : challenge_t['display_text']
    
    case challenge['challenge_type']
    when 'custom'
    when 'game' 
      game = Game.includes(:home_team,:away_team).find_by_game_id(challenge['game_id'])
      #challenge['challenge_expression'] = display_text.delete("^<>a-zA-Z 0-9")
      challenge['challenge_expression'] = display_text;
      begin
        challenge['challenge_expression']["?"] = ' in the '+game.home_team['name']+' vs. '+game.away_team['name']+' game?'
      rescue
        challenge['challenge_expression']["."] = ' in the '+game.home_team['name']+' vs. '+game.away_team['name']+' game?'
      end
    when 'team'
      challenge['challenge_expression'] = display_text
    when 'player'
      case challenge['challenge_subtype']
      when 'any'
        if (!challenge.featured)
          team1 = Team.find_by_team_id(challenge.player1['team_id'])
        end
        challenge['challenge_expression'] = display_text
      else  
        challenge['challenge_expression']["{PLAYER}"] = 
          '<strong>'+challenge.player1['first']+' '+
          challenge.player1['last']+'</strong> or <strong>'+
          challenge.player2['first']+' '+
          challenge.player2['last']+'</strong>'
      end
    end
    
    return challenge
  end
end