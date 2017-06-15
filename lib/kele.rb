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

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end
  
  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end