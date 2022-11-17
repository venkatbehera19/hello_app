class PostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

    def create
        @post = current_user.posts.build(post_params)
        @post.image.attach(params[:post][:image])
        respond_to do |format|
            if @post.save
                format.html { redirect_to root_url, :flash => { :success => "Post Created"} }
            else
                @feed_items = current_user.feed.paginate(page: params[:page])
                format.html { render 'static_pages/home', status: :unprocessable_entity }
                # render 'static_pages/home'
            end
        end
    end

    def destroy
        @post.destroy
        flash[:danger] = "Post deleted."
        redirect_to request.referrer || root_url 
    end

    private
        def post_params 
            params.require(:post).permit(:content, :image)
        end

        def logged_in_user
            unless logged_in?
                store_location
                flash[:danger] = "Please log in."
                redirect_to login_url
            end
        end

        def correct_user
            @post = current_user.posts.find_by(id: params[:id])
            redirect_to root_url if @post.nil?
        end
end
