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
end