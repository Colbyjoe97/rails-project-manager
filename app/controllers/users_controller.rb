class UsersController < ApplicationController
  before_action :validate_user, only: [:edit, :update]
  before_action :user_check, except: [:index, :new, :login, :create]

  def index
  end
  
  def new
  end

  def create
    user = User.new(user_params)
    if user.valid?
      user.save
      session[:user_id] = user.id
      redirect_to user_path user.id
    else
      flash[:errors] = user.errors.full_messages
      redirect_to :back
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.valid?
      @user.save
      redirect_to user_path @user
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to :back
    end
  end

  def show
    @user = User.find(params[:id])
    @projects = Project.where(user: @user)
  end

  def login
    render 'login'
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def validate_user
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to edit_user_path current_user
    end
  end
end
