class PostsController < ApplicationController


    def new

        authorize
        if !!params[:topic_id]
            @topic = Topic.find(params[:topic_id])
            authorize_topic(@topic)
            @post = Post.new
            @post.postable = @topic
            render 'topics/show'
        elsif !!params[:post_id]
            @post = Post.find(params[:post_id])
            authorize_topic(@post.topic)
            @reply = Post.new
            @reply.postable = @post
            @reply.content = "[#{@post.user.name}](#{user_path(@post.user)})" unless @post.first_level_reply?
            render 'posts/show'
        else
            not_found
        end
        
    end

    def create
        authorize
        if !!params[:topic_id]
            @topic = Topic.find(params[:topic_id])
            authorize_topic(@topic) 
            @post = Post.new(post_params)
            @post.postable = @topic
            @post.user = current_user
            if @post.save
                Notification.create(user: @topic.user, content: "<a href='#{user_path(@post.user)}'>#{@post.user.name}</a> responded to <a href='#{topic_path(@topic)}'>#{@topic.title}</a>")
                redirect_to topic_path(@topic)
            else
                flash[:danger] = "#{post.user.name}, your post was too long"
                render 'new'
            end
        elsif !!params[:post_id]
            @post = Post.find(params[:post_id])
            authorize_topic(@post.topic)
            @reply = Post.new(post_params)
            @reply.postable = @post
            @reply.user = current_user
            if @reply.save
                Notification.create(user: @post.user, content: "<a href='#{user_path(@reply.user)}'>#{@reply.user.name}</a> responded to <a href='#{topic_path(@post.topic)}'>your post</a>")
                redirect_to topic_path(@post.topic)
            else
                flash[:danger] = "#{post.user.name}, your post was too long"
                render 'new'
            end
        else
            not_found
        end
        
    end


    def index
        
    end


    def edit

        post = Post.find(params[:id])
        authorize_post(post)
        if !!params[:topic_id]
            @post = post
            @topic = Topic.find(params[:topic_id])
            authorize_topic(@topic)
            render 'topics/show'
        elsif !!params[:post_id]
            @reply = post
            @post = Post.find(params[:post_id])
            authorize_topic(@post.topic)
            render 'posts/show'
        else
            not_found
        end

    end

  
    def update

        post = Post.find(params[:id])
        authorize_post(post)
        if !!params[:topic_id]
            @post = post
            @topic = Topic.find(params[:topic_id])
            authorize_topic(@topic)
            if @post.update(post_params)
                redirect_to topic_path(@topic)
            else  
                flash[:danger] = "#{post.user.name}, your post was too long"
                render 'edit'
            end
        elsif !!params[:post_id]
            @reply = post
            @post = Post.find(params[:post_id])
            authorize_topic(@post.topic)
            if @reply.update(post_params)
                redirect_to topic_path(@post.topic)
            else
                flash[:danger] = "#{post.user.name}, your post was too long"
                render 'edit'
            end
        else
            not_found
        end

    end

    def destroy
        @post = Post.find(params[:id])
        authorize_post(@post)
        deleted = @post.destroy
        redirect_to topic_path(deleted.topic)
    end

    private

    def post_params
        params.require(:post).permit(:content)
    end
    
end