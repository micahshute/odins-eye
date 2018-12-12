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
                redirect_to topic_path(@topic)
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
        @post = Post.find(params[:id])
        authorize_post(@post)
        if !!params[:topic_id]
            @topic = Topic.find(params[:topic_id])
            authorize_topic(@topic)
            render 'topics/show'
        elsif !!params[:post_id]
            
        else
            not_found
        end
    end

  

    def update
        @post = Post.find(params[:id])
        authorize_post(@post)
        if !!params[:topic_id]
            @topic = Topic.find(params[:topic_id])
            if @post.update(post_params)
                redirect_to topic_path(@topic)
            else  
                flash[:danger] = "#{post.user.name}, your post was too long"
                render 'edit'
            end
        elsif !!params[:post_id]


        else
            not_found
        end

    end

    def destroy

    end

    private

    def post_params
        params.require(:post).permit(:content)
    end
    
end