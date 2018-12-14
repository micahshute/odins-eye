class TopicsController < ApplicationController

    before_action :authorize, only: [:new, :create]

    def new
        @topic = Topic.new
        4.times do 
            @topic.tags.build
        end
        @tag_types = Tag.most_popular(10)
    end

    def create
        @topic = Topic.new(topic_params)
        @topic.user = current_user
        if @topic.save
            flash[:success] = "Congratulations, your topic was published"
            redirect_to user_topic_path(current_user, @topic)
        else
            @tag_types = Tag.most_popular(10)
            raise @topic.errors.inspect
            flash[:danger] = "#{@topic.user.name}, there was a problem publishing your topic"
            render 'new'
        end
    end

    def show
        @logged_in = logged_in?
        @topic = Topic.where(id: params[:id]).includes(:user, :tags).includes(posts: {reactions: :reaction_type}).first
        @user = current_user
        @topic.update_views unless current_user == @topic.user
    end

    def edit
        @topic = Topic.find(params[:id])
        authorize(@topic.user)
        needed_tags = 4 - @topic.tags.length
        needed_tags.times do 
            @topic.tags.build
        end
        @tag_types = Tag.most_popular(10)

    end

    def index
        @logged_in = logged_in?
        if (@tag_type = TagType.find_by(id: params[:tag_id]))
            @group_by = @tag_type
            @topics = @tag_type.topics
        elsif (@user = User.find_by(id: params[:user_id]))
            @group_by = @user
            @topics = @user.topics
        else
            not_found
        end
       
    end

    def update
        @topic = Topic.find(params[:id])
        authorize(@topic.user)
        @topic.tags.destroy_all
        @topic.update(topic_params)
        if @topic.validate
            flash[:success] = "Congratulations, your topic was updated"
            redirect_to user_topic_path(current_user, @topic)
        else
            flash[:danger] = "#{@topic.user.name}, there was a problem updating your topict"
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
        if authorize
            @topics = current_user.saved_topics
        end
    end

    private

    def topic_params
        params.require(:topic).permit(
            [:title, :content,
                tags_attributes: [
                    :tag_type_name
                ]
            ]
        )
    end
    
end