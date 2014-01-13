class AddDisplayTextToChallenges < ActiveRecord::Migration
  def self.up
    add_column :challenges, :display_text, :string
  end

  def self.down
    remove_column :challenges, :display_text
  end
end
