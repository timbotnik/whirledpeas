require 'test_helper'
require 'json'

class Api::ChallengesControllerTest < ActionController::TestCase
    
  test "should create a game challenge" do
    user1 = users(:user1)
    game1 = games(:game1)
    assert_difference('Challenge.count') do
      @request.cookies['number'] = user1.fb_number
      @request.cookies['clearance'] = user1.clearance
      post(:create_game, :challenge => { 
        :template_id => 'game_turnovers',
        :game_id => game1.game_id,
        :stakes => "loser buys mango & sticky rice", 
        :public => true,
        :featured => true,
        :logo_url => "http://www.thaikitchenchester.com/"
        })       
    end # assert_difference

    apiResponse = JSON.parse(@response.body)
    puts JSON.pretty_generate(apiResponse)
    assert(apiResponse['success'])
    
    get :index
    apiResponse = JSON.parse(@response.body)
    
    assert(apiResponse['success'])
    assert(apiResponse['data'].length > 0)

  end
  
  test "should create a team challenge" do
    user1 = users(:user1)
    team1 = teams(:team1)
    assert_difference('Challenge.count') do
      @request.cookies['number'] = user1.fb_number
      @request.cookies['clearance'] = user1.clearance
      post(:create_team, :challenge => { 
        :template_id => 'team_passes',
        :team_id => team1.team_id,
        :stakes => "loser buys mango & sticky rice", 
        :public => true,
        :featured => true,
        :logo_url => "http://www.thaikitchenchester.com/"
        })       
    end # assert_difference

    apiResponse = JSON.parse(@response.body)
    puts JSON.pretty_generate(apiResponse)
    assert(apiResponse['success'])
    
    get :index
    apiResponse = JSON.parse(@response.body)
    
    assert(apiResponse['success'])
    assert(apiResponse['data'].length > 0)

  end
  
  test "should list challenges" do
    get :index
    apiResponse = JSON.parse(@response.body)
    assert(apiResponse['success'])
    assert(apiResponse['data'].length > 0)
  end


  test "should respond to a challenge" do
    challenge1 = challenges(:challenge1)
    user2 = users(:user2)
    assert_difference('ChallengeResponse.count') do
      post(:respond, :data => { 
        :challenge_id => challenge1.id,
        :response => "duck noodles", 
        :user_id => user2.id, 
        :status => "pending",
        })      
    end # assert_difference
    apiResponse = JSON.parse(@response.body)
    assert(apiResponse['success'])
    
    get(:details, {
      :id => challenge1.id
      })
    apiResponse = JSON.parse(@response.body)
    
    assert(apiResponse['success'])
    assert(apiResponse['data'].length > 0)

  end  
end
