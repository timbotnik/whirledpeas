class User < ActiveRecord::Base
  has_many :authentications
  validates :fb_number, :presence => true
  validates :role, :inclusion => { :in => [:user, :admin] }
  
  def role
    read_attribute(:role).to_sym
  end
  
  def role= (value)
    write_attribute(:role, value.to_s)
  end
  
end