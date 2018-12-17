class ApplicationController < ActionController::Base
    helper_method :logged_in?
    helper_method :current_user
    helper_method :time_of_day
    helper_method :time_from_now
    helper_method :parse_date
    helper_method :display_date_short
    helper_method :display_date_long
    helper_method :markdown

    private

    ## MARK: Authorization Methods

    def current_user
        User.find_by(id: session[:user_id])
    end

    def logged_in?
        !current_user.nil?
    end

    def authorize(user=nil)
        if user.nil?
            not_authorized("#{'<a href="/login">Login</a>'} or #{'<a href="/signup">Signup</a>'} to view this page!") unless logged_in?
            !!current_user
        else
            not_authorized unless user == current_user
            true
        end
    end

    def authorize_classroom_entry(classroom)
        authorize
        not_authorized("You are not enrolled in this class") unless (current_user.classrooms.include?(classroom) or current_user.enrolled_classes.include?(classroom))
    end

    def authorize_topic(topic)
        return true if topic.public?
        authorize_classroom_entry(topic.classroom)
    end


    def authorize_post(post)
        authorize
        not_authorized("You do not own this post") unless current_user == post.user
    end

    def current_user_is?(user)
        user == current_user
    end

    def authorize_admin
        authorize
        not_authorized("You must be an admin to view this page.") unless current_user.admin 
        true
    end

    def not_authorized(msg = "You are not authorized to view that page")
        flash[:danger] = msg
        render(:file => File.join(Rails.root, 'public/403.html.erb'), :status => 403, :layout => false)
    end

    def log_in(user)
        raise ArgumentError.new("You man only log in a user, not a #{user.class}.") unless user.is_a? User
        session[:user_id] = user.id
    end

    # MARK: MISC Helpers

    def time_of_day
        hour = Time.now.to_s.split(" ")[1].split(":")[0].to_i
        if hour < 12
            "Morning"
        elsif hour < 17
            "Afternoon"
        else
            "Evening"
        end
    end

    def time_from_now(time)
        seconds = Time.now - time
        if seconds < 60
            return "#{seconds.to_i} seconds ago"
        elsif seconds < 3600
            return "#{(seconds / 60.0).to_i} minutes ago"
        elsif seconds < 86400
            return "#{(seconds / 3600.0).to_i} hours ago"
        elsif seconds < 604800
            return "#{(seconds / 86400.0).to_i} days ago"
        elsif seconds < 2419200
            return "#{(seconds / 604800.0).to_i} weeks ago"
        else
            return "on #{time}"
        end
    end

    def parse_date(date)
        data = date.to_s.split('-')
        year = data[0]
        month = data[1]
        day = data[2].split(" ").first
        "#{month}/#{day}/#{year}"
    end

    def display_date_short(date)
        date.to_s.split(" ").slice(1,3).join(" ")
    end

    def display_date_long(date)
        date.strftime('%a %d %b %Y')
    end

    def markdown(markdown)
        Kramdown::Document.new(markdown, parse_block_html: true, syntax_highlighter: :rouge, syntax_highlighter_opts: {line_numbers: false}).to_html
    end

    def not_found(msg = nil)
        flash[:danger] = msg unless msg.nil?
        raise ActionController::RoutingError.new('Not Found')
    end

    def last_page
        request.referer
    end

    def clean_hash(hash)
        ret_hash = {}
        hash.each do |k,v|
            if v.is_a? Array
                vals = v.compact
                ret_hash[k] = vals if vals.length > 0 
            else
                ret_hash[k] = v unless v.nil?
            end
        end
        ret_hash
    end 

  
end
