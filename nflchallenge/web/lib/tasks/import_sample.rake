task :import_sample => :environment do
   puts 'importing teams...'
   StatsImporter.import_teams

   puts 'importing game schedule...'
   StatsImporter.import_games
   
   puts 'importing player list...'
   StatsImporter.import_players
   
   puts 'importing stats...'
   StatsImporter.import_stats(GameWeek.current)
   
   puts 'done.'
end