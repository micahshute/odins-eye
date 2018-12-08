class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(all_user_params)
        if @user.save
            log_in(@user)
            flash[:success] = "Welcome #{@user.name}!"
            redirect_to home_path
        else
            flash[:danger] = "Oops! There was trouble making your acount."
            render 'new'
        end
    end

    def show

    end

    def edit

    end

    def update

    end

    def home
        authorize
        @user = current_user
    end

    private

    def user_params(*args)
        params.require(:user).permit(*args)
    end

    def all_user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end