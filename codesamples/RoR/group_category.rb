class GroupCategory < ActiveRecord::Base
  
  validates :name, presence: true, length: { in: 0..255 }
  
  has_and_belongs_to_many :groups

end
