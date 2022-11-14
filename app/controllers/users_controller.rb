class UsersController < ApplicationController
    def index
        @users = User.all
    end

    def show 
        @user = User.find(params[:id])
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
                log_in @user
                format.html { redirect_to @user, :flash => { :success => "User Created Successfully."} }
            else
                format.html { render :new, status: :unprocessable_entity }
            end
        end
    end
    def update 
        @user = User.find(params[:id])
        if @user.update(user_params)
            redirect_to users_path
        else 
            render :edit
        end
    end
    
    def destroy 
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_path
    end

    private
    # strong parameters
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end