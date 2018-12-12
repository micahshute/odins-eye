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
end