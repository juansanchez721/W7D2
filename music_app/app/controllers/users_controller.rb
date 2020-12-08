class UsersController < ApplicationController


    def new
        #signing up for first time
        @user = User.new
        render :new
    end

    def create

        @user = User.new(user_params)
        if @user.save #save runs validations on the user params (email, password) based on user model validations
            session[:session] = @user.session_token  #set session token inside of session cookie equal to user's session_token value
            flash[:success] = 'Welcome new user. You have successfully signed up to our website.'
            redirect_to user_url(@user)
        else
            render :new 
        end
    end

    def show
        @user = User.find_by(params[:email])
        # @user = User.find(params[:id])

        render :show
    end


    def user_params

        params.require(:user).permit(:email, :password)

    end


end