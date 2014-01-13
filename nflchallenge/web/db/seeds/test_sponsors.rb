puts 'loading sponsors...'

@sponsor1 = Sponsor.find_by_name('Bloomberg') || Sponsor.create(
  :name => 'Bloomberg',
  :url => 'http://www.bloomberg.com',
  :logo => '/images/sponsor.png',
  :intro => 'This is sample text given by the administrator'
)