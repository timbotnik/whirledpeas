class ChallengeResponse < ActiveRecord::Base
	validates :challenge_id, :presence => true, 
	                         :numericality => true
	validates :response, :length => { :in => 1..255 }
  validates :status, :inclusion => { :in => [:pending, :responded, :won, :lost] }
  
  belongs_to :challenge
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id', :primary_key => 'id'
  belongs_to :player, :class_name => 'Player', :foreign_key => 'response', :primary_key => 'player_id'
  belongs_to :team, :class_name => 'Team', :foreign_key => 'response', :primary_key => 'team_id'
  
  @@json_options = {:include => [:user,:player,:team]}
  
  def status
    read_attribute(:status).to_sym
  end
  
  def status= (value)
    write_attribute(:status, value.to_s)
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
