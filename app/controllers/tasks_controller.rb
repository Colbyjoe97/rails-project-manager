class TasksController < ApplicationController
  before_action :user_check
  before_action :authenticate_user, only: [:update, :destroy, :edit]

  def index
  end

  def new
  end

  def show
  end

  def edit
    @task = Task.find(params[:id])
    @status = [
      { id: 'not-started', name: 'Not Started' },
      { id: 'in-progress', name: 'In Progress' },
      { id: 'complete', name: 'Complete'}
    ]
    @status.each do |stat|
      if stat[:id] == @task.status
        @task_status = stat[:name]
      end
    end
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    if task.valid?
      task.save
      redirect_to "/projects/#{task.project.id}"
    else
      flash[:errors] = task.errors.full_messages
      redirect_to :back
    end
  end

  def create
    project = Project.find(task_params[:project_id])
    if current_user.id == project.user.id
      task = Task.new(task_params)
      if task.valid?
        task.save
      else
        flash[:errors] = task.errors.full_messages
      end
    else
      flash[:wrongUser] = "You can only do that to your own projects / tasks!"  
    end
    redirect_to :back
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to :back, notice: 'Task was destroyed' }
      format.json{ head :no_content }
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :status, :project_id)
  end

  def authenticate_user
    task = Task.find(params[:id])
    if current_user.id != task.project.user.id
      flash[:wrongUser] = "You can only do that to your own projects / tasks!"
      redirect_to :back
    end
  end
end
