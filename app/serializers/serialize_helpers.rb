module SerializeHelpers

    def display_date_long(date)
        date.strftime('%a %d %b %Y')
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

    
end