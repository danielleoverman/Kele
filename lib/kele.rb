require 'httparty'
require 'json'

class Kele
  include HTTParty

  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { "email": email, "password": password })
    puts response
    raise "That is an invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  private

  def get_me (auth_token)
    response = self.class.get(api_url('users/me'), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end