class Api::SponsorsController < Api::ApiController
  before_filter :validate_api_role
  
  def index
    @sponsors = Sponsor.all
    response = ApiSuccess.new(@sponsors)
    render :json => response
  end

  def show
    @sponsor = Sponsor.find(params[:id])
    response = ApiSuccess.new(@sponsor)
    render :json => response
  end
  
  def create
    @sponsor = Sponsor.new({
      :name => params[:sponsor][:name],
      :url => params[:sponsor][:url],
      :logo => params[:sponsor][:logo]
    })
    @sponsor.save!
    response = ApiSuccess.new(@sponsor)
    render :json => response
  end
    
  def update
    @sponsor = Sponsor.find(params[:id])
    @sponsor.update_attributes!(params[:sponsor])
    response = ApiSuccess.new(@sponsor)
    render :json => response
  end
    
end
