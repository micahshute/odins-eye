class SessionsController < ApplicationController

    def login

    end

    def create
        if @user = User.find_by(email: params[:user][:email])
            if @user.authenticate(params[:user][:password])
                log_in(@user)
                flash[:success] = "Welcome back, #{@user.name}"
                redirect_to dashboard_path
            else
                flash[:danger] = "Improper login information entered."
                redirect_to login_path
            end
        else
            flash[:danger] = "Improper login information entered."
            redirect_to login_path
        end
    end

    def googleAuth
        access_token = request.env["omniauth.auth"]
        user = User.from_google(access_token)
        if user.save
            flash[:success] = "Welcome, #{user.name}"
            log_in(user)
            redirect_to dashboard_path
        else
            flash[:danger] = "There was a problem logging you in"
            redirect_to root_path
        end

    end

    def logout
        session.delete(:user_id)
        redirect_to root_path
    end
    
end