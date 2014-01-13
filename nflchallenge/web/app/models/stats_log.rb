class StatsLog < ActiveRecord::Base
	validates :status, :inclusion => { :in => [:pending, :importing, :imported, :error] }
	
	def status
    read_attribute(:status).to_sym
  end
  
  def status= (value)
    write_attribute(:status, value.to_s)
  end
end
