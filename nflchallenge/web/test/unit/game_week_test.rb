require 'test_helper'

class GameWeekTest < ActiveSupport::TestCase
  
  test "should test game week generation" do
    for week in 0...17
      week_starts_at = Time.parse(NflConfig.get('season', 'starts_at')) + (week * 7 * 24 * 60 * 60)
      puts "\nWeek Starting: " + week_starts_at.to_s
      for day in 0...7
        game_time = week_starts_at
        game_time += (day * 24 * 60 * 60) + (rand(23 - week_starts_at.hour) * 60 * 60) + (rand(60) * 60)
    
        expected_week_start = week_starts_at
        expected_week_end = week_starts_at + (7 * 24 * 60 * 60) - 1
        expected_week_id = week + 1
      
        game_week = GameWeek.new(game_time)
        puts "\nGame Time:\t" + game_time.to_s
        puts "Week Starts:\t" + game_week.starts_at.to_s
        puts "Week Ends:\t" + game_week.ends_at.to_s
        puts "Week ID:\t" + game_week.week_id.to_s
      
        assert_equal(game_week.starts_at, expected_week_start)
        assert_equal(game_week.ends_at, expected_week_end)
        assert_equal(game_week.week_id, expected_week_id)
      end
    end
  end
  
end
