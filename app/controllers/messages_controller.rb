class MessagesController < ApplicationController


    def new
        if authorize
            @user = User.find(params[:user_id])
            @message = Message.new
            @messages = Message.conversation(current_user, @user)
        end
    end

    def create
        if authorize
            sender = current_user
            reciever = User.find(params[:user_id])
            @message = Message.new(message_params)
            @message.sender = sender
            @message.reciever = reciever
            if @message.save
                redirect_to messages_from_user_path(reciever)
            else
                flash[:danger] = "Oops! There was an error sending this message"
                @messages = Message.conversation(sender, reciever)
                @user = reciever
                render 'new'
            end
        end
    end

    def inbox
        if authorize
            @user = current_user
            @messages = @user.group_all_messages
        end
    end

    def thread
        @sender = User.find(params[:id])
        if authorize
            Message.thread(to: current_user, from: @sender).each{ |msg| msg.viewed = true; msg.save}
            @messages = Message.conversation(current_user, @sender)
        end
    end

    def find_reciever
        authorize
        user_email = params[:user].split("::").last.strip
        if (reciever = User.find_by(email: user_email))
            redirect_to new_user_message_path(reciever)
        else    
            not_found
        end
    end

    private

    def message_params
        params.require(:message).permit(:content)
    end 

end