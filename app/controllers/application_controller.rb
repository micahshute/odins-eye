class ApplicationController < ActionController::Base
    helper_method :logged_in?
    helper_method :current_user


    private

    def current_user
        User.find_by(id: session[:user_id])
    end

    def logged_in?
        !current_user.nil?
    end

    def authorize(user=nil)
        if user.nil?
            not_authorized("#{'<a href="/login">Login</a>'} to view this page!") unless logged_in?
        else
            not_authorized unless user == current_user
        end
    end

    def authorize_classroom_entry(classroom)
        not_authorized("You are not enrolled in this class") unless (current_user.classrooms.include?(classroom) or current_user.enrolled_classes.include?(classroom))
    end

    def current_user_is?(user)
        user == current_user
    end

    def authorize_admin
        authorize
        not_authorized("You must be an admin to view this page.") unless current_user.admin 
    end

    def not_authorized(msg = "You are not authorized to view that page")
        flash[:danger] = msg
        render(:file => File.join(Rails.root, 'public/403.html.erb'), :status => 403, :layout => false)
    end
    
end
