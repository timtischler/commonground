class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_or_initialize_by(google_uid: auth["uid"])
    user.update!(
      email: auth["info"]["email"],
      name: auth["info"]["name"],
      avatar_url: auth["info"]["image"]
    )
    session[:user_id] = user.id
    redirect_to chats_path, notice: "Signed in successfully."
  rescue StandardError
    redirect_to login_path, alert: "Authentication failed. Please try again."
  end

  def failure
    redirect_to login_path, alert: "Authentication failed. Please try again."
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Signed out."
  end
end
