class TopicsController < ApplicationController

    before_action :authorize, only: [:new, :create]

    def new
        @topic = Topic.new
        @tag_types = Tag.most_popular(10)
    end

    def create
        @topic = Topic.new(topic_params)
        @topic.user = current_user
        if @topic.validate
            tags = []
            for i in 1..4 do 
                tags << params["topic_tags_#{i}"] unless params["topic_tags_#{i}"] == ""
            end
            tag_result = @topic.tag(tags)
            if tag_result == true
                flash[:success] = "Congratulations, your topic was published"
                redirect_to user_topic_path(current_user, @topic)
            else
                @error = tag_result
                flash[:danger] = "#{@topic.user.name}, there was a problem publishing your topic"
                @tag_types = Tag.most_popular(10)
                render 'new'
            end
        else
            flash[:danger] = "Oops! There was a problem publishing your post"
            render 'new'
        end
    end

    def show
        @topic = Topic.where(id: params[:id]).includes(:user, :tags).includes(posts: {reactions: :reaction_type}).first
    end

    def edit
        @topic = Topic.find(params[:id])
        authorize(@topic.user)
        @tag_types = Tag.most_popular(10)

    end

    def index
        @topic = Topic.all.last
    end

    def update
        @topic = Topic.find(params[:id])
        authorize(@topic.user)
        @topic.update(topic_params)
        @topic.tags.destroy_all
        if @topic.validate
            tags = []
            for i in 1..4 do 
                tags << params["topic_tags_#{i}"] unless params["topic_tags_#{i}"] == ""
            end
            tag_result = @topic.tag(tags)
            if tag_result == true
                flash[:success] = "Congratulations, your topic was updated"
                redirect_to user_topic_path(current_user, @topic)
            else
                @error = tag_result
                flash[:danger] = "#{@topic.user.name}, there was a problem updating your topic"
                @tag_types = Tag.most_popular(10)
                render 'edit'
            end
        else
            flash[:danger] = "Oops! There was a problem updating your post"
            render 'edit'
        end
    end

    def destroy
        @topic = Topic.find(params[:id])
        authorize(@topic.user)
        @topic.destroy
        flash[:success] = "You successfully deleted your topic"
        redirect_to root_path
    end

    def reading_list
        authorize
        @topics = current_user.saved_topics
    end

    private

    def topic_params
        params.require(:topic).permit([:title, :content])
    end
    
end