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

  def get_me
    response = self.class.get(api_url('users/me'), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
     response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
     @mentor_availability = JSON.parse(response.body)
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post(api_url("checkpoint_submissions"),
      body: {
        "assignment_branch": assignment_branch,
        "assignment_commit_link": assignment_commit_link,
        "checkpoint_id": checkpoint_id,
        "comment": comment,
        "enrollment_id": enrollment_id
        },
      headers: {"authorization" => @auth_token})
     puts response
  end

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end