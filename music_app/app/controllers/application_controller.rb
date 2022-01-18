class ApplicationController < ActionController::Base

    helper_method :current_user

    def current_user
        return nil if session[:session_token].nil?
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in?
        #session[:session_token] == @user.session_token IS THIS RIGHT?
    end

    def login!(user)
        session[:session_token] = @user.session_token
    end

    def logout!
        current_user.reset_session_token!
        session[:session_token] = nil
        @current_user = nil
    end
end
