class ApiException < ApiResponse

  def initialize(e)
    super(false, e.message, nil)
  end
  
end