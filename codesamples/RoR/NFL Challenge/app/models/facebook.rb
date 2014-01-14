class Facebook
  require 'open-uri'
  require 'pp'
  
  def self.token
    fb = { :app_id => '266077590075606', :client_secret => '716a48b8edf50097794a13c770b000c7' }
    return open('https://graph.facebook.com/oauth/access_token?client_id='+fb[:app_id]+'&client_secret='+fb[:client_secret]+'&grant_type=client_credentials').read
  end
  
  def self.get_request(request_id,token)
    url = URI.encode('https://graph.facebook.com/'+request_id+'?'+token)
    return open(url).read
  end
        
end
