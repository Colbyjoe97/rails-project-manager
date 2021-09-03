class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_check
    if not current_user
      redirect_to ('/')
    end
  end
  helper_method :user_check

  def find_user
      @user = User.find_by(id: params[:id])
      redirect_to user_path(current_user.id) unless @user
  end
  helper_method :find_user
end
