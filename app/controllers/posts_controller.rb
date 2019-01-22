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
            respond_to do |f|
                f.html { render 'posts/show' }
                f.json { render jsonapi: @post }
            end
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
                respond_to do |f|
                    f.html { redirect_to topic_path(@topic) }
                    f.json { render jsonapi: @post, 
                        include: [user: [:id, :name]]
                    }
                end
            else
                flash[:danger] = "#{post.user.name}, your post was too long"
                respond_to do |f|
                    f.html { render 'new' }
                    f.json { render jsonapi_errors: @post.errors }
                end
                
            end
        elsif !!params[:post_id]
            @post = Post.find(params[:post_id])
            authorize_topic(@post.topic)
            @reply = Post.new(post_params)
            @reply.postable = @post
            @reply.user = current_user
            if @reply.save
                Notification.create(user: @post.user, content: "<a href='#{user_path(@reply.user)}'>#{@reply.user.name}</a> responded to <a href='#{topic_path(@post.topic)}'>your post</a>")
                respond_to do |f|
                    f.html { redirect_to topic_path(@topic) }
                    f.json { render jsonapi: @reply, 
                        include: [user: [:id, :name]]
                    }
                end
            else
                flash[:danger] = "#{post.user.name}, your post was too long"
                respond_to do |f|
                    f.html { render 'new' }
                    f.json { render jsonapi_errors: @post.errors }
                end
            end
        else
            not_found
        end
        
    end



    def edit

        post = Post.find(params[:id])
        authorize_post(post)
        if !!params[:topic_id]
            @post = post
            @topic = Topic.find(params[:topic_id])
            authorize_topic(@topic)
            respond_to do |f|
                f.html { render 'topics/show' }
                f.json {
                    data = {
                        data: {
                            postableType: "topic",
                            postableId: @topic.id,
                            errors: {
                                exist: false
                            },
                            content: nil,
                            newPost: false
                        }
                    }
                    render json: JSON.generate(data)
                }
            end
        elsif !!params[:post_id]
            @reply = post
            @post = Post.find(params[:post_id])
            authorize_topic(@post.topic)
            respond_to do |f|
                f.html { render 'posts/show' }
                f.json { 
                    data = {
                        data: {
                            postableType: "post",
                            postableId: @post.id,
                            errors: {
                                exist: false
                            },
                            content: nil,
                            newPost: false
                        }
                    }
                    render json: JSON.generate(data)
                }
            end
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