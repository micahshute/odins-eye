class ClassroomsController < ApplicationController


    def new
        if authorize
            @user = current_user
            @classroom = Classroom.new
        end
    end

    def create

    end

    def show

    end

    def edit

    end

    def index

    end

    def update

    end

    def destroy

    end
    
end