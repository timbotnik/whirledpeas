require 'test_helper'

class GameTest < ActiveSupport::TestCase
  
  test "should list games" do
    games = Game.list
    puts "\nGame List:"
    games.each do |game|
      home_team = game.home_team
      away_team = game.away_team
      puts home_team.name + " vs. " + away_team.name + ', ' + game.starts_at.to_s
    end
    assert(games.length == 2)
  end
  
  
  test "should list games for this week" do
    games = Game.list_for_week(GameWeek.current)
    puts "\nGame List For Week:"
    games.each do |game|
      home_team = game.home_team
      away_team = game.away_team
      puts home_team.name + " vs. " + away_team.name + ', ' + game.starts_at.to_s
    end
    assert(games.length == 1)
  end
  
  test "should list games for week and team" do
    team = teams(:team1)
    games = team.find_games_for_week(GameWeek.current)
    puts "\nGame List For Week And Team: " + team.name
    games.each do |game|
      home_team = game.home_team
      away_team = game.away_team
      puts home_team.name + " vs. " + away_team.name + ', ' + game.starts_at.to_s
    end
  end
end