class SessionsController < ApplicationController

    def new
        #renders form (new.html.erb) in views that allows user to log in
    end

    def create #log in
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
        if @user.nil?
            flash[:errors] = ["Invalid Credentials"]
            redirect_to new_session_url
        else
            login!(@user) #will reset user's session token and set equal to session's session token in login!(user) method in applicationcontroller
            redirect_to user_url(@user.id)
        end
    end

    def destroy #log out
        logout! #will reset user's session token and set session's session token to nil in logout! method
        redirect_to new_session_url
    end
end