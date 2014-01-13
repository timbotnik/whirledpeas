require 'test_helper'

class StatsImporterTest < ActiveSupport::TestCase
  
  test "should import statistics" do
    

    StatsImporter.import_teams
    teams = Team.all
    teams.each do |team|
      puts team.city + ' ' + team.name
    end
  
    StatsImporter.import_games
    games = Game.all
    games.each do |game|
      puts game.game_id.to_s + ': ' + game.starts_at.to_s + ' home: ' + game.home_team_id.to_s + ' away: ' + game.away_team_id.to_s
    end
  
    StatsImporter.import_players
    players = Player.all
    players.each do |player|
      puts player.player_id + ': ' + player.first + ' ' + player.last + ', ' + player.position + ' for the ' + player.team.name
    end

    StatsImporter.import_stats(GameWeek.current)

    game_stats = GameStats.all
    game_stats.each do |game_stat|
      puts game_stat.to_json
    end
    player_stats = PlayerStats.all
    player_stats.each do |player_stat|
      puts player_stat.to_json
    end

  end
end
