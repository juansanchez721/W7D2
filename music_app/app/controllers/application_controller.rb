class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in? #methods available to the views

    def logged_in?

        !!current_user

    end

    def current_user
    
        return nil unless session[:session_token] #does session cookie have session_token attribute
        User.find_by(session_token: session[:session_token])
    end

    def log_in_user!(user)

        session[:session_token] = user.reset_session_token!

    end

end
