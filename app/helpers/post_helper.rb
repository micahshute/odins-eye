module PostHelper


    def retrieve_replies(post)
        reply_queue = post.posts.to_a
        harvested_posts = []
        while reply_queue.length > 0
            curr_post = reply_queue.shift
            harvested_posts << curr_post
            reply_queue = reply_queue + curr_post.posts.to_a
        end
        harvested_posts
        # harvested_posts.sort{ |a,b| b.created_at <=> a.created_at}
    end

    def reactions(post)
        if logged_in? 
            user = current_user
            render 'posts/logged_in_reactions', post: post, genius_color: reaction_color(user.thinks_is_genius?(post)) , like_color: reaction_color(user.likes?(post)), dislike_color: reaction_color(user.dislikes?(post))
        else
            render 'posts/logged_out_reactions', post: post
        end
    end

    def reaction_color(function_output)
        function_output ? 'aqua' : 'charcoal'
    end

    def post_report_dropdown(post)
        if logged_in? 
            render 'posts/report_dropdown', post: post
        else
            nil
        end
    end

    def dropdown_options(post)
        options = []
        if post.user == current_user 
            edit_path = post.postable.is_a?(Topic) ? edit_topic_post_path(post.postable, post) : edit_post_reply_path(post.postable, post)
            delete_path = post.postable.is_a?(Topic) ? topic_post_path(post.postable, post) : delete_post_reply_path(post.postable, post)
            options << OpenStruct.new(action: "Edit", path: edit_path, data_method: "get")
            options << OpenStruct.new(action: "Delete", path: delete_path, data_method: "delete")
        end
        options << OpenStruct.new(action: "Report this post",  path: create_post_reaction_path(post, ReactionType::ID[:report]), data_method: "post")
        render 'posts/dropdown_options', options: options
    end

    def post_form_path(post)
        if post.new_record?
            return post.postable.is_a?(Topic) ? topic_posts_path(post.postable) : post_replies_path(post.postable)
        else
            return post.postable.is_a?(Topic) ? topic_post_path(post.postable, post) : post_reply_path(post.postable, post)
        end
    end

    
end