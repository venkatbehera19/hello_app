module SessionsHelper
    # logs in the given user
    def log_in(user)
        session[:user_id] = user.id
    end
    def remember(user)
        user.remember 
        cookies.permanent.encrypted[:user_id] = user.id;
        cookies.permanent[:remember_token] = user.remember_token
    end
    # return a current logged-in user (if-any)
    def current_user 
        if ( user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif ( user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(:remember,cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end
    # returns true if the user is logged In, false otherwise
    def logged_in? 
        !current_user.nil?
    end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def log_out
        forget(current_user)
        session.delete(:user_id);
        @current_user = nil
    end
    # returns true if the given user is the current user
    def current_user?(user)
        user && user == current_user
    end

    # redirect to store location (or to the default)
    def redirect_back_or(default)
        redirect_to (session[:forwarding_url] || default);
        session.delete(:forwarding_url)
    end

    # Store the URL trying to be accessed.
    def store_location 
        # puts "store_location  #{request.original_url}"
        session[:forwarding_url] = request.original_url if request.get?
    end
end
