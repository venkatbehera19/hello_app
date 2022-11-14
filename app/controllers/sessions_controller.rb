class SessionsController < ApplicationController
  # First we need to add session helper in application controller
  def new
  end
  def create
    email = params[:session][:email]
    password = params[:session][:password]
    user = User.find_by(email:email.downcase)
    respond_to do |format|
      if user&.authenticate(password)
        log_in user
        format.html { redirect_to user, :flash => { :success => "Login Successfull."} }
      else
        # puts "Not Available"
        format.html { redirect_to login_path, :flash => { :danger => "Invalid email/password combination"}}
      end
    end
  end
  def destroy
    log_out
    redirect_to root_url
  end
  private
  def sessions_params
    params.require(:session).permit(:email, :password)
  end
end
