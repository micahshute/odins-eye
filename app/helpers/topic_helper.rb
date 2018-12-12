module TopicHelper

    def editing?(topic)
        !topic.new_record?
    end

    def topic_options(topic)
        if logged_in?
            user = current_user
            like_selected = user.likes?(topic)
            genius_selected = user.thinks_is_genius?(topic)
            dislike_selected = user.dislikes?(topic)
            saved = user.topic_saved?(topic)
            render 'logged_in_options', topic: topic, like_selected: like_selected, genius_selected: genius_selected, dislike_selected: dislike_selected, saved: saved
        else
            render 'logged_out_options'
        end
    end

    def topic_report_dropdown(topic)
        if logged_in? 
            text = current_user.reported?(topic) ? "Un-report this topic" : "Report this topic"
            render 'report_dropdown', topic: topic, text: text
        else
            nil
        end
    end
end