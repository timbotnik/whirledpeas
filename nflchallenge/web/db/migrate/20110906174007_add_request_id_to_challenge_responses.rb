class AddRequestIdToChallengeResponses < ActiveRecord::Migration
  def self.up
    add_column :challenge_responses, :request_id, :string
  end

  def self.down
    remove_column :challenge_responses, :request_id
  end
end
