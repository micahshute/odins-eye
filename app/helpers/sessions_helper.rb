module SessionsHelper

    def has_error(object, field)
        if object.nil?
            return ""
        else
            return object.errors[field].any? ? "is-invalid" : "is-valid"
        end
    end

end