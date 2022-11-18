class PasswordResetsController < ApplicationController
  before_action :get_user ,        only: [:edit, :update]
  before_action :valid_user ,      only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    respond_to do |format|
      if @user 
        @user.create_reset_digest
        @user.send_password_reset_email
        format.html { redirect_to root_url, :flash => { :info => "Email sent with password reset instructions."} }
      else
        format.html { redirect_to new_password_reset_url, :flash => { :danger => "Email address not found."} }
      end
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
  end

  def update 
    respond_to do |format|
        if params[:user][:password].empty?
          @user.errors.add(:password, "can not be empty")
          format.html { render :edit, status: :unprocessable_entity }
        elsif @user.update(user_params)
          log_in @user
          @user.update_attribute(:reset_digest, nil)
          format.html { redirect_to @user, :flash => { :success => "Password has been reset."} }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
    end
  end

  private 
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user 
      @user = User.find_by(email: params[:email])
    end

    def valid_user 
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired? 
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
