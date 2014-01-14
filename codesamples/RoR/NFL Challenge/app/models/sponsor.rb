class Sponsor < ActiveRecord::Base
	validates :name,  :presence => true
  validates :url, :presence => true
  validates :logo, :presence => true
  validates :intro, :presence => true
  
  has_many :challenges
  
  @@json_options = { :include => { :challenges => { :include => :game }  } }
  
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
