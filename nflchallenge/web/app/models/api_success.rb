class ApiSuccess < ApiResponse

  def initialize(data, message = "success")
    super(true, message, data)
  end
  
end