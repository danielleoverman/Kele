require 'httparty'
require 'json'


require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap 

  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { "email": email, "password": password })
    puts response
    raise "That is an invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url('users/me'), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
     response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
     @mentor_availability = JSON.parse(response.body)

  def get_messages(page_number=nil)
    if page_number == nil
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(api_url("message_threads?page=#{page_number}"), headers: { "authorization" => @auth_token })
    end    
    @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped)
    options = {body: {sender: email, recipient_id: recipient_id, token: nil, subject: subject, stripped-text: stripped-text}, headers: { "authorization" => @auth_token }}
    self.class.post(api_url("messages"), options)
  end

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end