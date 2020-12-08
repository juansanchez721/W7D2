class SessionsController < ApplicationController


    def new
        #logging in, not signing up.
        render :new 

    end

    def create

        user = User.find_by_credentials(params[:email], params[:password])

        if user 
            log_in_user!(user)
            flash[:success] = 'Welcome back user. you have successfully logged in'
            redirect_to user_url
        else
            flash.now[:error] = 'Wrong combination. Please try logging in again.'
            render :new, status: 401
        end



    end

    def destroy
        current_user.reset_session_token!
        session[:session_token] = nil     
        flash[:success] = "successfully logged out"
        redirect_to new_user_url

    end


end