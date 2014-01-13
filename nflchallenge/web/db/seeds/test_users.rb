puts 'loading users...'

@user1 = User.find_by_fb_number('42501287') || User.create(
  :fb_number => '42501287',
  :fb_token => 'token1',
  :clearance => 'clearance1',
  :email => 'kyle@carrotcreative.com',
  :nickname => 'Kyle MacDonald',
  :role => 'admin'
  )
  
@user2 = User.find_by_fb_number('100000214085631') || User.create(
  :fb_number => '100000214085631',
  :fb_token => 'token2',
  :clearance => 'clearance2',
  :email => 'fb5@goodfellaz.com',
  :nickname => 'Johnny Fifthman',
  :role => 'user'
  )

@user3 = User.find_by_fb_number('100000212585579') || User.create(
  :fb_number => '100000212585579',
  :fb_token => 'token3',
  :clearance => 'clearance3',
  :email => 'fb1@goodfellaz.com',
  :nickname => 'Johnny Firstman',
  :role => 'user'
  )

