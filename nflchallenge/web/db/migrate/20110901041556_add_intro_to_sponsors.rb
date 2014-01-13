class AddIntroToSponsors < ActiveRecord::Migration
  def self.up
    add_column :sponsors, :intro, :string
  end

  def self.down
    remove_column :sponsors, :intro
  end
end
