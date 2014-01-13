task :update_scores => :environment do
   
   puts 'closing challenges...'
   ScoreKeeper.close_active_challenges
   
   puts 'updating scores...'
   result = ScoreKeeper.update_scores_task
   puts result.to_s + ' scores updated.'
   
   puts 'done.'
end