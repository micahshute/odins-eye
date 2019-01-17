class ReactionsController < ApplicationController

    def create
        authorize
        user = current_user
        reactable = nil
        if (topic_id = params[:topic_id])
            reactable = Topic.find topic_id
            authorize_topic(reactable)
        elsif (post_id = params[:post_id])
            reactable = Post.find post_id
            authorize_topic(reactable.topic)
        end

        if (reaction_type_id = params[:reaction_type_id].to_i)

            case reaction_type_id
            when ReactionType::ID[:like]
                if user.likes?(reactable)
                    user.likes_for(reactable).destroy_all
                else
                    user.like(reactable)
                    create_notification(for_user: reactable.user, reaction_type: :like, reactor: user, reactable: reactable)
                end
            when ReactionType::ID[:dislike]
                if user.dislikes?(reactable)
                    user.dislikes_for(reactable).destroy_all
                else
                    user.dislike(reactable)
                    create_notification(for_user: reactable.user, reaction_type: :dislike, reactor: user, reactable: reactable)
                end
            when ReactionType::ID[:genius]
                if user.thinks_is_genius?(reactable)
                    user.genius_reaction_for(reactable).destroy_all
                else
                    user.is_genius(reactable)
                    create_notification(for_user: reactable.user, reaction_type: :genius, reactor: user, reactable: reactable)
                end
            when ReactionType::ID[:report]
                if user.reported?(reactable)
                    user.reports_for(reactable).destroy_all
                else
                    user.report(reactable)
                end
            else
                not_found
            end

            redirect_to last_page
        else
            not_found
        end

    end


    private

    def create_notification(for_user: , reaction_type: , reactor: , reactable: )
        reactable_type = reactable.is_a?(Topic) ? reactable.title : "your post"
        path = reactable.is_a?(Topic) ? topic_path(reactable) : topic_path(reactable.topic)
        img = "<i class='material-icons'>#{ReactionType::ICON[reaction_type]}</i>"
        Notification.create(user: for_user , content: "<a href='#{user_path(reactor)}'>#{reactor.name}</a> ::  #{img} ::  <a href='#{path}'>  #{reactable_type}</a>")
    end

end