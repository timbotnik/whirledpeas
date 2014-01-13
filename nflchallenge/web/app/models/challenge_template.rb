class ChallengeTemplate < ActiveRecord::Base
	validates :template_id, :presence => true
  validates :template_expression, :presence => true
  validates :challenge_type, :presence => true, :inclusion => { :in => [:team, :player, :game, :fun] }
  validates :template_expression, :presence => true
  
  def challenge_type
    read_attribute(:challenge_type).to_sym
  end
  
  def challenge_type= (value)
    write_attribute(:challenge_type, value.to_s)
  end
  
  def self.list
     @templates = YAML::load(File.open(::Rails.root.to_s + '/config/challenge_templates.yml'))
  end
  
  def self.get_from_config(template_id)
    @templates = self.list
    @templates[template_id]
  end
  
end
