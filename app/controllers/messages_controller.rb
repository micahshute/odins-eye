class MessagesController < ApplicationController

    before_action :authorize

    def new
        @user = User.find(params[:user_id])
        @message = Message.new
    end

    def create

    end

    def inbox
        if authorize
            @user = current_user
            @messages = @user.recieved_messages_by_sender
        end
    end

    def thread
        @sender = User.find(params[:id])
        if authorize
            Message.thread(to: current_user, from: @sender).each{ |msg| msg.viewed = true; msg.save}
        end
    end

    def update

    end

    def destroy

    end
    
end