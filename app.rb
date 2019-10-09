require "sinatra"
require_relative "./models.rb"
require_relative "api_authentication.rb"

get "/secret" do
	api_authenticate!
	halt 200, {message: "This message is super confidential. I like wings. and beer too."}.to_json
end

#retrieve
get "/tasks/" do
	api_authenticate!
	tasks = Task.all(user_id: current_user.id)
	if tasks
		return posts.to_json
	else
		halt 404, {message: "User not found"}.to_json
	end
end
#create
post "/tasks/add" do
	api_authenticate!
	newTask = params["task"]

	if text
		task = Task.new
		task.user_id = current_user.id
		task.text = newTask
		task.save
		halt 201, {"message": "New task added"}.to_json
	else
		halt 400, {"message": "Task body missing"}
	end
end
#update
#update task
patch "/task/edit/:task_id" do
	api_authenticate!
	task_id = params["task_id"]
	new_Text = params["new_text"]
	completed = params["completed"]
	if task_id
		task = Task.get(task_id)
		if task
			if task.user_id == current_user.id
				task.text = new_Text
				task.save
				if completed == "true"
					task.completed = true
				end
			else
				halt 401, {message: "You are unauthorized to modify this task"}.to_json
			end
		else
			halt 404, {message: "Task not found"}.to_json
		end
	else
		halt 401, {message: "Missing Task ID parameter"}.to_json
	end
end

#delete
delete "/task/delete/:task_id" do
	api_authenticate!
	task_id = params["task_id"]
	if task_id
		task = Task.get(task_id)
		if task
			if task.user_id == current_user.id
				task.destroy
			else
				halt 401, {message: "You are unauthorized to modify this task"}.to_json
			end
		else
			halt 404, {message: "Task not found"}.to_json
		end
	else
		halt 401, {message: "Missing Task ID parameter"}.to_json
	end
end