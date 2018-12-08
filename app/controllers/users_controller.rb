class UsersController < ApplicationController

    def new
        
    end

    def create

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

end