class ApiController < ApplicationController

    def check_email
        body = JSON.parse(request.body.read)
        email = body["email"]
        user = User.find_by(email: email)
        if !!user
            render json: JSON.generate({data: true})
        else
            render json: JSON.generate({data: false})
        end
    end

    def logged_in
        render json: JSON.generate({ logged_in: !!session[:user_id] })
    end

    def get_current_user
        user = User.find_by(id: session[:user_id])
        if !!user
            render jsonapi: user
        else
            render json: JSON.generate({data: nil})
        end
    end

    def most_recent_topics

        per_page = params[:per_page].to_i
        offset = params[:offset].to_i
        per_page = 10 if(per_page == 0)
        per_page = [25, per_page].min
        recent_topics = Topic.newest_public(per_page, offset).includes(:posts, :reactions)
        render jsonapi: recent_topics,
            class: {Topic: SerializableTopic, User: SerializableUser},
            include: [user: [:name, :id]]

    end

    def user_reactions
        if session[:user_id]
            render jsonapi: current_user.reactions
        else
            render json: JSON.generate({data: nil, msg: "You are not logged in"})
        end
    end

    def user_reactable_reaction
        if params[:user_id] == "current-user"
            if session[:user_id]
                user = current_user
                reactable = params[:reactable].chomp('s').camelcase.constantize.find_by(id: params[:reactable_id])
                if user and reactable
                    reactions = Reaction.user_reactable(user, reactable).map{ |rxn| rxn.reaction_type_id }
                    if reactable.is_a? Topic
                        rxns_hash = {
                            like: reactions.include?(ReactionType::ID[:like]),
                            dislike: reactions.include?(ReactionType::ID[:dislike]),
                            genius: reactions.include?(ReactionType::ID[:genius]),
                            save: user.saved?(reactable)
                        }
                        render json: JSON.generate({data: rxns_hash})
                    elsif reactable.is_a? Post
                        rxns_hash = {
                            like: reactions.include?(ReactionType::ID[:like]),
                            dislike: reactions.include?(ReactionType::ID[:dislike]),
                            genius: reactions.include?(ReactionType::ID[:genius]),
                        }
                        render json: JSON.generate({data: rxns_hash})
                    else
                        render json: JSON.generate({data: nil, msg: "Incorrect type entered"})
                    end
                else
                    render json: JSON.generate({data: nil, msg: "Item or user not found"})
                end
              
            else
                render json: JSON.generate({data: nil, msg: "You are not logged in in"})
            end
        else
            user = User.find_by(id: params[:user_id])
            reactable = params[:reactable].chomp('s').camelcase.constantize.find_by(id: params[:reactable_id])
            if !!user and !!reactable
                reactions = Reaction.user_reactable(user, reactable).map{ |rxn| rxn.reaction_type_id }
                if reactable.is_a? Topic
                    rxns_hash = {
                        like: reactions.include?(ReactionType::ID[:like]),
                        dislike: reactions.include?(ReactionType::ID[:dislike]),
                        genius: reactions.include?(ReactionType::ID[:genius]),
                        save: user.saved?(reactable)
                    }
                    render json: JSON.generate({data: rxns_hash})
                elsif reactable.is_a? Post
                    rxns_hash = {
                        like: reactions.include?(ReactionType::ID[:like]),
                        dislike: reactions.include?(ReactionType::ID[:dislike]),
                        genius: reactions.include?(ReactionType::ID[:genius]),
                    }
                    render json: JSON.generate({data: rxns_hash})
                else
                    render json: JSON.generate({data: nil, msg: "Incorrect type entered"})
                end
            else
                render json: JSON.generate({data: nil, msg: "Item or user not found"})
            end
        end
    end

    #def saved_topics

    #end

    def query_reacted_reactables
        
        if session[:user_id]
            reactable = params[:reactable].chomp('s').camelcase.constantize.find_by(id: params[:reactable_id])
            if reactable
                user = current_user
                outcome = user.send(params[:reaction] + "?", reactable)
                render json: JSON.generate({data: outcome})
            else
                render json: JSON.generate({data: nil, msg: "Item does not exist"})
            end
        else
            render json: JSON.generate({data: nil, msg: "You are not logged in in"})
        end

    end


    def post_nested_replies
        post = Post.find_by(id: params[:id])
        if post
            replies = post.nested_replies
            render jsonapi: replies,
                include: [user: [:name, :id]],
                fields: { users: [:id, :name]}
        else
            render json: JSON.generate({data: null, msg: "Unable to find Post"})
        end
    end

end