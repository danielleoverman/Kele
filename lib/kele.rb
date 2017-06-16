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


  def get_roadmap()
    response = self.class.get(api_url("roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)  
  end

  def get_checkpoint()
    response = self.class.get(api_url("checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)  
  end


  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end