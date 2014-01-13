class BaselineSchema < ActiveRecord::Migration
  def self.up

    create_table :users do |t|
      t.column :fb_number, :string, :limit => 24, :null => false
      t.column :fb_token, :string, :limit => 180, :null => false
      t.column :clearance, :integer, :limit => 8, :null => false
      t.column :email, :string, :limit => 255
      t.column :nickname, :string, :limit => 64
      t.column :role, :string, :limit => 16, :default => 'user', :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
    add_index(:users, [:fb_number], :name => :fb_id_idx)
    add_index(:users, [:email], :name => :email_idx)

    create_table :challenges do |t|
      t.column :stakes, :string, :limit => 255
      t.references :user
      t.column :template_id, :string, :limit => 16
      t.column :challenge_type, :string, :limit => 16
      t.column :challenge_subtype, :string, :limit => 16
      t.column :challenge_expression, :string, :limit => 255
      t.column :result, :string, :limit => 32
      t.column :sponsor_id, :integer
      t.column :game_id, :integer
      t.column :player_filter, :string, :limit => 64
      t.column :player1_id, :string
      t.column :player2_id, :string
      t.column :picks, :string, :limit => 64
      t.column :public, :boolean, :default => '1', :null => false
      t.column :featured, :boolean, :default => '0', :null => false
      t.column :status, :string, :limit => 16
      t.column :closes_at, :timestamp
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end

    create_table :challenge_responses do |t|
      t.references :challenge
      t.column :response, :string, :limit => 255
      t.column :status, :string, :limit => 16, :default => 'pending', :null => false
      t.references :user
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end

  end

  def self.down
    drop_table :users
    drop_table :challenges
    drop_table :challenge_responses
  end
end
