require "sinatra"
require_relative "./models.rb"
require_relative "api_authentication.rb"

get "/secret" do
	api_authenticate!
	halt 200, {message: "This message is super confidential. I like wings. and beer too."}.to_json
end