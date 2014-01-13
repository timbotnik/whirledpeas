puts 'loading responses...'

@resp = ChallengeResponse.create(
  :user_id => @user1.id,
  :response => '920',
  :challenge_id => @ch_game_winner.id,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user2.id,
  :response => '920',
  :challenge_id => @ch_game_winner.id,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user3.id,
  :response => '3200',
  :challenge_id => @ch_game_winner.id,
  :status => 'lost'
  )



@resp = ChallengeResponse.create(
  :user_id => @user1.id,
  :response => '920',
  :challenge_id => @ch_team_yards.id,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user2.id,
  :response => '920',
  :challenge_id => @ch_team_yards.id,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user3.id,
  :response => '3200',
  :challenge_id => @ch_team_yards.id,
  :status =>  'lost'
  )



@resp = ChallengeResponse.create(
  :user_id => @user1.id,
  :response => 'BRA371156',
  :challenge_id => @ch_player_passing_yards.id,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user2.id,
  :response => 'BRA371156',
  :challenge_id => @ch_player_passing_yards.id,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user3.id,
  :response => 'BOL517890',
  :challenge_id => @ch_player_passing_yards,
  :status =>  'lost'
  )
  
  

@resp = ChallengeResponse.create(
  :user_id => @user1.id,
  :response => 'BRA371156',
  :challenge_id => @ch_player_passing_yards_sp.id,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user2.id,
  :response => 'BRA371156',
  :challenge_id => @ch_player_passing_yards_sp,
  :status => 'won'
  )

@resp = ChallengeResponse.create(
  :user_id => @user3.id,
  :response => 'BOL517890',
  :challenge_id => @ch_player_passing_yards_sp,
  :status =>  'lost'
  )