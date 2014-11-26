class Group < ActiveRecord::Base

  validates :name, presence: true, length: { in: 0..255 }
  validates :description, length: { in: 0..255 }, allow_blank: true
  validates :latitude, numericality: true, allow_blank: true
  validates :longitude, numericality: true, allow_blank: true
  
  has_many :follows, foreign_key: "following_group_id"
  has_many :followers, through: :follows, source: :user
  has_and_belongs_to_many :group_categories
  has_many :posts, foreign_key: "wall_group_id"
  belongs_to :avatar
  belongs_to :admin_user, class_name: "User", foreign_key: "admin_user_id"

  scope :by_popularity, -> { order("user_count DESC") }
  scope :by_follower, ->(user) { joins(:followers).where("follows.user_id = ?", user.id) }
  scope :by_name, ->(search_text) { where("groups.name LIKE ?", "%#{search_text}%") }
  scope :by_categories, ->(category_names) { joins(:group_categories).where("group_categories.name = (?)", category_names) }

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
end
