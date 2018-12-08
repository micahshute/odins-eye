module UsersHelper
    def error_msg_for(object, field)
        if object.errors[field].any?
            "<p class='error-text'>#{object.errors[field].join("; ").capitalize}</p>"
        else
            ""
        end
    end
end