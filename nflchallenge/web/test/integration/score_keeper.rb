require 'test_helper'
 
class ScoreKeeperTest < ActionController::IntegrationTest
  fixtures :users, :games, :game_stats, :player_stats, :stats_logs, :challenges, :challenge_responses
  
  test "should keep scores" do
    ScoreKeeper.close_active_challenges
    ScoreKeeper.update_scores_task
    Challenge.all.each do |challenge|
      puts JSON.pretty_generate(JSON.parse(challenge.to_json))
    end
  end
end