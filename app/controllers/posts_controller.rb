class PostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destory]
    before_action :correct_user,   only: [:destory]

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            flash[:success] = "Post Created"
            redirect_to root_url
        else
            @feed_items = current_user.feed.paginate(page: params[:page])
            render 'static_pages/home'
        end
    end

    def destory
        puts "#{@post}"
        # @post.destory
        # flash[:danger] = "Post deleted."
        # redirect_to request.referrer || root_url 
    end

    private
        def post_params 
            params.require(:post).permit(:content)
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
