class StatsLog < ActiveRecord::Migration
  def self.up

    create_table :stats_logs do |t|
      t.column :status, :string, :limit => 16, :default => 'pending', :null => false
      t.column :week_id, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :stats_logs
  end
end
