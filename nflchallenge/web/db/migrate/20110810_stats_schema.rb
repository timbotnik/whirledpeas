class StatsSchema < ActiveRecord::Migration
  def self.up

    create_table :games do |t|
      t.column :game_id, :integer, :null => false
      t.column :home_team_id, :integer, :null => false
      t.column :away_team_id, :integer, :null => false
      t.column :starts_at, :datetime, :null => false
    end
  
    create_table :player_stats do |t|
      t.column :player_id, :string, :limit => 32, :null => false
      t.column :game_id, :integer, :null => false
      t.column :week_id, :integer, :limit => 4, :null => false
      t.column :catches, :integer, :limit => 4, :default => 0, :null => false
      t.column :touchdowns, :integer, :limit => 4, :default => 0, :null => false
      t.column :sacks, :integer, :limit => 4, :default => 0, :null => false
      t.column :times_sacked, :integer, :limit => 4, :default => 0, :null => false
      t.column :interceptions, :integer, :limit => 4, :default => 0, :null => false
      t.column :interceptions_thrown, :integer, :limit => 4, :default => 0, :null => false
      t.column :fumbles, :integer, :limit => 4, :default => 0, :null => false
      t.column :fumbles_forced, :integer, :limit => 4, :default => 0, :null => false
      t.column :rushing_attempts, :integer, :limit => 4, :default => 0, :null => false
      t.column :rushing_yards, :integer, :default => 0, :null => false
      t.column :rushing_touchdowns, :integer, :default => 0, :null => false
      t.column :passing_attempts, :integer, :limit => 4, :default => 0, :null => false
      t.column :completed_passes, :integer, :limit => 4, :default => 0, :null => false
      t.column :passing_yards, :integer, :default => 0, :null => false
      t.column :passing_touchdowns, :integer, :default => 0, :null => false
      t.column :receiving_yards, :integer, :default => 0, :null => false
      t.column :receiving_touchdowns, :integer, :default => 0, :null => false
      t.column :yards_after_catch, :integer, :default => 0, :null => false
    end
  
    create_table :teams do |t|
      t.column :team_id, :integer, :limit => 64, :null => false
      t.column :name, :string, :limit => 64, :null => false
      t.column :city, :string, :limit => 64, :null => false
      t.column :abbr, :string, :limit => 5, :null => false
      t.column :stadium, :string, :limit => 64, :null => false
    end
  
    create_table :game_stats do |t|
      t.column :game_id, :integer, :null => false
      t.column :week_id, :integer, :limit => 4, :null => false
      t.column :team_id, :integer, :null => false
      t.column :points_scored, :integer, :limit => 4, :default => 0, :null => false
      t.column :points_allowed, :integer, :limit => 4, :default => 0, :null => false
      t.column :touchdowns, :integer, :limit => 4, :default => 0, :null => false
      t.column :rushing_attempts, :integer, :limit => 4, :default => 0, :null => false
      t.column :rushing_yards, :integer, :default => 0, :null => false
      t.column :rushing_touchdowns, :integer, :default => 0, :null => false
      t.column :passing_attempts, :integer, :limit => 4, :default => 0, :null => false
      t.column :completed_passes, :integer, :limit => 4, :default => 0, :null => false
      t.column :passing_yards, :integer, :default => 0, :null => false
      t.column :passing_touchdowns, :integer, :default => 0, :null => false
      t.column :turnovers, :integer, :limit => 4, :default => 0, :null => false
      t.column :interceptions, :integer, :limit => 4, :default => 0, :null => false
      t.column :fumbles_forced, :integer, :limit => 4, :default => 0, :null => false
      t.column :sacks, :integer, :limit => 4, :default => 0, :null => false
      t.column :punts, :integer, :limit => 4, :default => 0, :null => false
    end

    create_table :players do |t|
      t.column :player_id, :string, :limit => 32, :null => false
      t.column :team_id, :integer, :null => false
      t.column :first, :string, :limit => 64, :null => false
      t.column :last, :string, :limit => 255, :null => false
      t.column :position, :string, :limit => 64, :null => false
      t.column :number, :integer, :limit => 3, :null => false
      t.column :status, :boolean, :default => '1', :null => false
    end

  end
  
  def self.down
    drop_table :games
    drop_table :player_stats
    drop_table :teams
    drop_table :game_stats
    drop_table :players
  end

end
