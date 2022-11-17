class SessionsController < ApplicationController
  # First we need to add session helper in application controller
  def new
  end

  def create
    email = params[:session][:email]
    password = params[:session][:password]
    user = User.find_by(email: email.downcase)
    respond_to do |format|
      if user&.authenticate(password)
        if user.activated?
          log_in user
          # remember user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user);
          # redirect_back_or user
          format.html { redirect_back_or user }
        else
          message = "Account not activated"
          message += "check your email for the activation link."
          format.html { redirect_to root_url, :flash => { :warning => message } }
        end
      else
        # puts "Not Available"
        format.html { redirect_to login_path, :flash => { :danger => "Invalid email/password combination"}}
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def sessions_params
    params.require(:session).permit(:email, :password)
  end
end
