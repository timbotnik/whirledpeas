class Api::ApiController < ApplicationController
  around_filter :catch_exceptions
  
  def catch_exceptions
    begin
      yield
    rescue => e
      response = ApiException.new(e)
      logger.error(e.message)
      render :json => response
    end
  end
  
  def validate_api_role
    if (@current_user['role'] != 'admin')
      msg = 'You must be an administrator to access this API.'
      response = ApiFailure.new(msg)
      logger.error(msg)
      render :json => response
    end
  end

end