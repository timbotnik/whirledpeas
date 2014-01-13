class Challenge < ActiveRecord::Base
  # Validations
  validates :user_id,              :presence => true, :numericality => true
  validates :public,               :inclusion => { :in => [true, false] }
  validates :featured,             :inclusion => { :in => [true, false] }
  validates :challenge_type,       :presence => true, :inclusion => { :in => [:team, :player, :game, :custom] }
	validates :challenge_expression, :presence => true
	validates :status,               :inclusion => { :in => [:pending, :active, :closed, :processing, :processed, :error] }
  
  # Relationships
  has_one     :user
  has_many    :challenge_responses
  #has_one     :game
  #has_one     :sponsor
  belongs_to  :sponsor, :class_name => 'Sponsor', :foreign_key => 'sponsor_id', :primary_key => 'id'
  belongs_to  :player1, :class_name => 'Player',  :foreign_key => 'player1_id', :primary_key => 'player_id'
  belongs_to  :player2, :class_name => 'Player',  :foreign_key => 'player2_id', :primary_key => 'player_id'
  belongs_to  :game,    :class_name => 'Game',    :foreign_key => 'game_id',    :primary_key => 'game_id'
  
  # Scopes
  scope :admin,    includes([:challenge_responses, :sponsor]).where('featured = ? AND challenge_type= "custom" AND result IS NULL',true).order('created_at DESC')
  scope :curated,  includes([:player1, :player2, :game]).where('sponsor_id IS NULL AND featured = ? AND status = "active"',true)
  scope :history,  lambda { |user_id| includes([ :challenge_responses, { :challenge_responses => :user }, { :challenge_responses => :player }, { :challenge_responses => :team }, :player1, :player2 ]).where('challenge_responses.user_id = ?', user_id) }
  scope :find_with_includes, lambda { |user_id| includes([ :challenge_responses, { :challenge_responses => :user }, { :challenge_responses => :player }, { :challenge_responses => :team }, :player1, :player2, :sponsor ]).where(:id => user_id).limit(1) }
  
  @@json_options        = { :include => [:challenge_responses,:player1,:player2,:sponsor,:game] }
  @@closing_time_offset = 60 * 60
  
  def set_winner 
    if (read_attribute(:status).to_s != 'active')
      id = read_attribute(:result)
      type = read_attribute(:challenge_type)
      case type.to_s
      when 'game'
        case read_attribute(:template_id).to_s
        when 'game_winner'
          write_attribute(:winner,Team.find_by_team_id(id.to_s))
        when 'game_yards'
          write_attribute(:winner,Team.find_by_team_id(id.to_s))
        end
      when 'team'
        write_attribute(:winner,Team.find_by_team_id(id.to_s))
      when 'player'
        write_attribute(:winner,Player.find_by_player_id(id.to_s))
      end
    end
  end
  
  def self.closing_time_offset
    @@closing_time_offset
  end
  
  def status
    read_attribute(:status).to_sym
  end
  
  def status= (value)
    write_attribute(:status, value.to_s)
  end
  
  def challenge_type
    read_attribute(:challenge_type).to_sym
  end
  
  def challenge_type= (value)
    write_attribute(:challenge_type, value.to_s)
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
