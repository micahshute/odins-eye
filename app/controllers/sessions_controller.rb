class SessionsController < ApplicationController

    def login

    end

    def create
        if @user = User.find_by(email: params[:user][:email])
            if @user.authenticate(params[:user][:password])
                session[:user_id] = @user.id
                flash[:success] = "Welcome back, #{@user.name}"
                redirect_to home_path
            else
                flash[:danger] = "Improper login information entered."
                redirect_to login_path
            end
        else
            flash[:danger] = "Improper login information entered."
            redirect_to login_path
        end
    end

    def logout
        session.delete(:user_id)
        redirect_to root_path
    end
    
end