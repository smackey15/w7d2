class UsersController < ApplicationController
    
    before_action :logged_in?, except: [:create, :new]
    #this ensures the user is logged in in order to update or delete their own information.

    def new
        #renders form (new.html.erb) in views that allows user to signup
    end

    def show
        @user = User.find(params[:id])
        render :show 
        #renders show page for the user with the passed in id
    end

    def create
        @user = User.new(user_params)
        if @user.save 
            login!(@user) #need to write this method in application controller
            render :show #or redirect_to user_url(@user.id)?
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new 
        end
    end

    private
    def user_params
        params.require(:user).permit(:email, :password)
    end
end