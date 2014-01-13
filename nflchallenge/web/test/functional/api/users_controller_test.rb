require 'test_helper'
require 'json'

class Api::UsersControllerTest < ActionController::TestCase
  
  test "should create a user" do
    assert_difference('User.count') do
      post :create, :data => { 
        :fb_number => 103,
        :fb_token => 'token',
        :clearance => 'clearance',
        :email => 'user1@goodfellaz.com',
        :nickname => 'user1',
        :role => 'user'
        }        
    end # assert_difference

    puts @response.body
    apiResponse = JSON.parse(@response.body)
    assert(apiResponse['success'])
    
    get :index
    apiResponse = JSON.parse(@response.body)
    
    assert(apiResponse['success'])
    assert(apiResponse['data'].length > 0)

  end
  
end
