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
            render 'topics/logged_in_options', topic: topic, like_selected: like_selected, genius_selected: genius_selected, dislike_selected: dislike_selected, saved: saved
        else
            render 'topics/logged_out_options', topic: topic
        end
    end

    def topic_report_dropdown(topic)
        if logged_in? 
            text = current_user.reported?(topic) ? "Un-report this topic" : "Report this topic"
            render 'topics/report_dropdown', topic: topic, text: text
        else
            nil
        end
    end

    def topic_list_header(grouped_by)
        if grouped_by.is_a?(TagType)
            render 'topics/tag_topics_header', tag_type: grouped_by
        elsif grouped_by.is_a?(User)
            render 'topics/user_topics_header', user: grouped_by
        else
            not_found
        end
    end

    def card_for(grouped_by, topics)
        if grouped_by.is_a?(TagType)
            tag_users = User.most_with_tag(grouped_by, 3)
            render 'topics/tag_index_card', topics: topics, tag_type: grouped_by, tag_users: tag_users
        elsif grouped_by.is_a?(User)
            render 'topics/user_index_card', topics: topics, user: grouped_by, user_tag_types: grouped_by.tag_types.shuffle.take(3).map{ |name| TagType.find_by(name: name) }
        else
            not_found
        end
    end
end