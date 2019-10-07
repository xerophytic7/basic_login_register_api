require "sinatra"
require_relative "./models.rb"
require_relative "api_authentication.rb"

get "/secret" do
	api_authenticate!
	halt 200, {message: "This message is super confidential. I like wings. and beer too."}.to_json
end

get "/tasks/:id" do
	api_authenticate!
	tasks = Task.all(user_id: current_user.id)
	if tasks
		return posts.to_json
	else
		halt 404, {message: "User not found"}.to_json
	end
end