class SponsorSchema < ActiveRecord::Migration
  def self.up

    create_table :sponsors do |t|
      t.column :name, :string, :limit => 80, :null => false
      t.column :url, :string, :limit => 250, :null => false
      t.column :logo, :string, :limit => 250, :null => false
    end
  
  end
  
  def self.down
    drop_table :sponsors
  end

end