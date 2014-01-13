class ApiFailure < ApiResponse

  def initialize(message = "failure", data = nil)
    super(false, message, data)
  end
  
end