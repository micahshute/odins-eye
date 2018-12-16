module UsersHelper
    def error_msg_for(object, field)
        if object.errors[field].any?
            "<p class='error-text small-text'>#{object.errors[field].join("; ").capitalize}</p>"
        else
            ""
        end
    end

    def stat_object(title, obj, option=nil)
        if obj.nil?
            render 'users/spec_title', title: "You do not have a #{title}".capitalize
        else
            if obj.is_a?(Topic)
                title = "#{title} (#{obj.send(option)})" unless option.nil?
                render 'users/spec_topic', title: title, topic: obj
            elsif obj.is_a?(Post)
                render 'users/spec_post', title: title, post: obj
            end
        end
    end

    def profile_stat_object(user, title, obj, option=nil)
        if obj.nil?
            render 'users/spec_title', title: "#{user.name} does not have a #{title}".capitalize
        else
            if obj.is_a?(Topic)
                title = "#{title} (#{obj.send(option)})" unless option.nil?
                render 'users/spec_topic', title: title, topic: obj
            elsif obj.is_a?(Post)
                render 'users/spec_post', title: title, post: obj
            end
        end
    end

    

end