class ProjectsController < ApplicationController
  before_action :validate_user, only: [:edit, :update]
  before_action :user_check
  
  def index
    @projects = Project.all.order! 'created_at DESC'
  end
  
  def show
    @project = Project.find(params[:id])
    @tasks = Task.where(project: @project).order! 'created_at DESC'
  end

  def create
    @project = Project.new(project_params)
    if @project.valid?
      @project.save
      redirect_to user_path current_user
    else
      flash[:errors] = @project.errors.full_messages
      redirect_to :back
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.user.id == current_user.id
      @project.update(project_params)
      if @project.valid?
        @project.save
        redirect_to project_path(@project)
      else
        flash[:errors] = @project.errors.full_messages
        redirect_to :back
      end
    else
      flash[:wrongUser] = "You can only do that to your own projects / tasks!"
      redirect_to :back
    end
  end

  def destroy
    project = Project.find(params[:id])
    if project.user.id == current_user.id
      task = Task.where(project: project)
      task.delete_all
      project.delete
      redirect_to user_path(current_user)
    else
      flash[:wrongUser] = "You can only do that to your own projects / tasks!"
      redirect_to :back
    end
  end

  private
  def project_params
    params.require(:project).permit(:name, :description, :user_id)
  end

  def validate_user
    @project = Project.find(params[:id])
    if @project.user != current_user
      redirect_to project_path @project
    end
  end
end