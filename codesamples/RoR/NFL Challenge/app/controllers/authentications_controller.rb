class AuthenticationsController < ApplicationController

def index
  @authentications = Authentication.all
end

def create
  #auth = request.env["rack.auth"]
  render :text => request.env["omniauth.auth"]
  #current_user.aiuthentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
  #flash[:notice] = "Authentication successful."
  #redirect_to authentications_url
end

def destroy
  @authentication = current_user.authentications.find(params[:id])
  @authentication.destroy
  flash[:notice] = "Successfully destroyed authentication."
  redirect_to authentications_url
end

end
