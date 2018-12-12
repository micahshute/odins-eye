class ReactionsController < ApplicationController

    def create
        authorize
        user = current_user
        reactable = nil
        if (topic_id = params[:topic_id])
            reactable = Topic.find topic_id
        elsif (post_id = params[:post_id])
            reactable = Post.find post_id
        end

        if (reaction_type_id = params[:reaction_type_id].to_i)

            case reaction_type_id
            when ReactionType::ID[:like]
                if user.likes?(reactable)
                    user.likes_for(reactable).destroy_all
                else
                    user.like(reactable)
                end
            when ReactionType::ID[:dislike]
                if user.dislikes?(reactable)
                    user.dislikes_for(reactable).destroy_all
                else
                    user.dislike(reactable)
                end
            when ReactionType::ID[:genius]
                if user.thinks_is_genius?(reactable)
                    user.genius_reaction_for(reactable).destroy_all
                else
                    user.is_genius(reactable)
                end
            when ReactionType::ID[:report]
                if user.reported?(reactable)
                    user.reports_for(reactable).destroy_all
                else
                    user.report(reactable)
                end
            else
                # byebug
                not_found
            end

            redirect_to last_page
        else
            # byebug
            not_found
        end

    end

end