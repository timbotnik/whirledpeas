class Api::UsersController < Api::ApiController
  
  before_filter :validate_api_role
  skip_before_filter :validate_api_role, :only => [:create]
  
  def me
    response = ApiSuccess.new(@current_user)
    render :json => response
  end
  
  def index
    @users = User.all
    response = ApiSuccess.new(@users)
    render :json => response
  end
  
  def show
    @user = User.find(params[:id])
    response = ApiSuccess.new(@user)
    render :json => response
  end
  
  def create
    data = { 
      :fb_token => params[:data][:fb_token],
      :fb_number => params[:data][:fb_number],
      :email => params[:data][:email],
      :nickname => params[:data][:nickname],
      :clearance => (Random.rand(999999-100000) + 100000)
    }
    existing = User.find_by_fb_number(data[:fb_number]) || User.new(data)
    existing.update_attributes!(data)
    self.set_cookie(data[:fb_number],data[:clearance])
    response = ApiSuccess.new('User has been updated successfully.')
    render :json => response
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes!(params[:user])
    response = ApiSuccess.new(@user)
    render :json => response
  end
  
end