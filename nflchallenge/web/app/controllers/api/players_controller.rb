class Api::PlayersController < Api::ApiController
  
  def search
    @players = Player.search(params[:post])
    response = ApiSuccess.new(@players)
    render :json => response
  end
    
end