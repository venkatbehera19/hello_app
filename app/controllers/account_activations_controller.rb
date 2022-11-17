class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        respond_to do |format|
            if user && !user.activated? && user.authenticated?(:activation, params[:id])
                user.activate 
                log_in user
                format.html { redirect_to user, :flash => { :success => "Account Activated"} }
            else
                format.html { redirect_to root_url, :flash => { :danger => "Invalid activation link"} }
            end
        end
    end
end
