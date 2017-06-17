require 'httparty'


require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap 

  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { "email": email, "password": password })
    puts response.code
    raise "That is an invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end