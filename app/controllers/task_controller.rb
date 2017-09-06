class TaskController < ApplicationController
  def create
    @task = Task.new(task_params)
    @task[:user_id] = session[:user_id]
    @story = @task.story
    @task.save
  end
  def delete
    @task = Task.find(params[:id])
    @task.destroy
  end
  def change_status
    @task = Task.find(params[:task_id])
    @task[:status] = params[:status]
    @task.save
  end
  private
    def task_params
      params.require(:task).permit(:title, :story_id)
    end
end
