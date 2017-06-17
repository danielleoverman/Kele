require 'httparty'

class Kele
  include HTTParty

  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { "email": email, "password": password })
    puts response.code
    raise "That is an invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

def get_messages(page_number=nil)
    if page_number == nil
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(api_url("message_threads?page=#{page_number}"), headers: { "authorization" => @auth_token })
    end    
    @messages = JSON.parse(response.body)
end

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end