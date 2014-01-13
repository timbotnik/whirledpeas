# SQLEditor export: Rails Migration
# id columns are removed
class Schemasql < ActiveRecord::Migration 
  def self.up


    create_table :challenge_templates do |t|
      t.column :name, :string, :limit => 64
      t.column :format, :string, :limit => 255
      t.column :type, :string, :limit => 16
      t.column :query, :string, :limit => 255
    end

    create_table :users do |t|
      t.column :fb_id, :integer, :limit => 20
      t.column :email, :string, :limit => 255
      t.column :nickname, :string, :limit => 64
      t.column :role, :string, :limit => 16, :default => 'user', :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
    add_index(:users, [:fb_id], :name => :fb_id_idx)
    add_index(:users, [:email], :name => :email_idx)

    create_table :challenges do |t|
      t.references :challenge_templates
      t.column :stakes, :string, :limit => 255
      t.references :users
      t.column :featured, :boolean, :default => '0', :null => false
      t.column :logo_url, :string, :limit => 512
      t.column :status, :string, :limit => 16
      t.column :closes_at, :timestamp
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end

    create_table :challenge_data do |t|
      t.references :challenges
      t.column :key, :string, :limit => 32
      t.column :value, :string, :limit => 255
    end

    create_table :comments do |t|
      t.references :challenges
      t.references :users
      t.column :comment, :string, :limit => 255
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end

    create_table :challenge_responses do |t|
      t.references :challenges
      t.column :response, :string, :limit => 255
      t.column :status, :string, :limit => 16, :default => 'pending', :null => false
      t.references :users
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end

  end

  def self.down
    drop_table :challenge_templates
    drop_table :users
    drop_table :challenges
    drop_table :challenge_data
    drop_table :comments
    drop_table :challenge_responses
  end
end
