class UsersController < ApplicationController
    before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
    before_action :correct_user,   only: [:edit, :update]
    before_action :admin_user,     only: :destroy
    def index
        # @users = User.all
        @users = User.where(activated: true).paginate(page: params[:page], per_page: 5)
    end

    def show 
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(page: params[:page], per_page: 5)
        @posts = @user.posts.paginate(page: params[:page], per_page: 5)
    end

    def new 
        @user = User.new
    end

    def edit 
        @user = User.find(params[:id])
    end

    def create 
        @user = User.new(user_params)
        respond_to do |format|
            if @user.save
                # log_in @user
                @user.send_activation_email  # UserMailer.account_activation(@user).deliver_now
                format.html { redirect_to root_url, :flash => { :info => "please check your email to activate your account."} }
            else
                format.html { render :new, status: :unprocessable_entity }
            end
        end
    end

    def update 
        @user = User.find(params[:id])
        respond_to do |format|
            if @user.update(user_params)
                format.html { redirect_to @user, :flash => { :success => "Profile Updated Successfully."} }
                # redirect_to users_path
            else 
                # render :edit
                format.html { render :edit, status: :unprocessable_entity }
            end
        end
    end
    
    def destroy 
        @user = User.find(params[:id])
        @user.destroy
        flash[:success] = "User Deleted"
        redirect_to users_path
    end
    
    private

    # strong parameters
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # confirm a loggedin user
    def logged_in_user
        unless logged_in?
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
        end
    end

    # confirms the correct user
    def correct_user 
        @user = User.find(params[:id])
        redirect_to root_url unless current_user?(@user)
    end

    # confirms an admin user
    def admin_user
        redirect_to root_url unless current_user.admin?
    end
end