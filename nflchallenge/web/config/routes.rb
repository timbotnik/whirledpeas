Www::Application.routes.draw do
  match 'login',  :controller => 'welcome', :action => 'login'
  match 'tab',    :controller => 'welcome', :action => 'index'

  #welcome
  match 'welcome/teamChallenge',    :controller => 'welcome', :action => 'teamChallenge'
  match 'welcome/gameChallenge',    :controller => 'welcome', :action => 'gameChallenge'
  match 'welcome/playerChallenge',  :controller => 'welcome', :action => 'playerChallenge'
  match 'welcome/challengeCurated', :controller => 'welcome', :action => 'challengeCurated'
  match 'welcome/history/:id',      :controller => 'welcome', :action => 'history'
  match 'welcome/history',          :controller => 'welcome', :action => 'history'
  match 'welcome/logout',           :controller => 'welcome', :action => 'logout'
  resources :welcome

  #challenge
  match 'challenges/step2_any/:id', :controller => 'challenges', :action => 'step2_any'
  match 'challenges/step2_pvp/:id', :controller => 'challenges', :action => 'step2_pvp'
  match 'challenges/:id',           :controller => 'challenges', :action => 'index'
  resources :challenges
  
  #admin
  match 'admin/import_games',       :controller => 'admin', :action => 'import_games'
  match 'admin/import_teams',       :controller => 'admin', :action => 'import_teams'
  match 'admin/import_players',     :controller => 'admin', :action => 'import_players'
  match 'admin/import_stats',       :controller => 'admin', :action => 'import_stats'
  match 'admin/update_scores',      :controller => 'admin', :action => 'update_scores'
  match 'admin/games',              :controller => 'admin', :action => 'games'
  match 'admin/teams',              :controller => 'admin', :action => 'teams'
  match 'admin/players',            :controller => 'admin', :action => 'players'
  match 'admin/challenges',         :controller => 'admin', :action => 'challenges'
  match 'admin/sponsors',           :controller => 'admin', :action => 'sponsors'
  match 'admin/stats',              :controller => 'admin', :action => 'stats'
  match 'admin/teamChallenge',      :controller => 'admin', :action => 'teamChallenge'
  match 'admin/gameChallenge',      :controller => 'admin', :action => 'gameChallenge'
  match 'admin/playerChallenge',    :controller => 'admin', :action => 'playerChallenge'
  match 'admin/prohibited',         :controller => 'admin', :action => 'prohibited'
  resources :admin
  
  root :to => "welcome#index"

  # Routes for API 
  namespace :api do
    match 'users/me',      :controller => 'users', :action => 'me'
    match 'challenges/custom',      :controller => 'challenges', :action => 'create_custom'
    match 'challenges/game',        :controller => 'challenges', :action => 'create_game'
    match 'challenges/team',        :controller => 'challenges', :action => 'create_team'
    match 'challenges/player',      :controller => 'challenges', :action => 'create_player'
    match 'challenges/respond',     :controller => 'challenges', :action => 'respond'
    match 'challenges/update/:id',  :controller => 'challenges', :action => 'update'
    match 'challenges/invite/:id',  :controller => 'challenges', :action => 'invite'
    match 'challenges/details/:id', :controller => 'challenges', :action => 'details'
    match 'sponsors/create',        :controller => 'sponsors',  :action => 'create'
    match 'sponsors/update/:id',    :controller => 'sponsors',  :action => 'update'
    match 'users/create',           :controller => 'users',     :action => 'create'
    match 'users/update/:id',       :controller => 'users',     :action => 'update'
    match 'users/show',             :controller => 'users',     :action => 'show'
    match 'players/search',         :controller => 'players',   :action => 'search'  
    resources :users
    resources :challenges
    resources :players
  end
end