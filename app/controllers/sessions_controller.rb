class SessionsController < ApplicationController
  def login
    user = User.find_by_email(user_params[:email]).try(:authenticate, user_params[:password])
    if user
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      flash[:error] = "Email or password is incorrect"
      redirect_to :back
    end
  end

  def logout
    reset_session
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
