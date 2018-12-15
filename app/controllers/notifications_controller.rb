class NotificationsController < ApplicationController

    def index
        if authorize
            @user = current_user
            @new_notifications = current_user.new_notifications.reverse
            @old_notifications = @user.sorted_notifications.reverse[@new_notifications.length, 5]
            @old_notifications = [] if @old_notifications.nil?
            @new_notifications.each{ |n| n.viewed = true; n.save }
        end
    end
    
end