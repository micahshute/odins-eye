class TopicsController < ApplicationController

    before_action :authorize, only: [:new]

    def new
        if params[:classroom_id]
            @classroom = Classroom.find(params[:classroom_id])
            @outer_nest = @classroom
            authorize(@classroom.professor)
            @topic = Topic.new
            4.times do 
                @topic.tags.build
            end
            @tag_types = Tag.most_popular(10)
        else
            @outer_nest = current_user
            @topic = Topic.new
            4.times do 
                @topic.tags.build
            end
            @tag_types = Tag.most_popular(10)
        end
    end

    def create
        if authorize
            @topic = Topic.new(topic_params)
            @topic.user = current_user
            if !!params[:classroom_id]
                classroom = Classroom.find params[:classroom_id]
                authorize(classroom.professor)
                @topic.classroom = classroom
            end
            if @topic.tags.all?{ |t| t.tag_type.validate }
                if @topic.save
                    flash[:success] = "Congratulations, your topic was published"
                    if @topic.classroom.nil?
                        redirect_to user_topic_path(current_user, @topic)
                    else
                        redirect_to classroom_topics_path(@topic.classroom)
                    end
                else
                    @tag_types = Tag.most_popular(10)
                    needed_tags = 4 - @topic.tags.length
                    needed_tags.times do 
                        @topic.tags.build
                    end
                    flash[:danger] = "#{@topic.user.name}, there was a problem publishing your topic"
                    render 'new'
                end
            else
                @tag_types = Tag.most_popular(10)
                needed_tags = 4 - @topic.tags.length
                needed_tags.times do 
                    @topic.tags.build
                end
                flash[:danger] = "#{@topic.user.name}, there was a problem publishing your topic"
                render 'new'
            end
        end
    end

    def show
        @logged_in = logged_in?
        @topic = Topic.where(id: params[:id]).includes(:user, :tags).includes(posts: {reactions: :reaction_type}).first
        @classroom = @topic.classroom unless @topic.classroom.nil?
        @user = current_user
        authorize_topic(@topic)
        @edit_path = @topic.classroom.nil? ? edit_topic_path(@topic) : edit_classroom_topic_path(@topic.classroom, @topic)
        @topic.update_views unless current_user == @topic.user
    end

    def edit
        if !!params[:classroom_id]
            @classroom = Classroom.find params[:classroom_id]
            authorize(@classroom.professor)
            @topic = Topic.find(params[:id])
            needed_tags = 4 - @topic.tags.length
            needed_tags.times do 
                @topic.tags.build
            end
            @tag_types = Tag.most_popular(10)
            @outer_nest = @classroom
        else
            @topic = Topic.find(params[:id])
            authorize(@topic.user)
            @outer_nest = @topic.user
            needed_tags = 4 - @topic.tags.length
            needed_tags.times do 
                @topic.tags.build
            end
            @tag_types = Tag.most_popular(10)
        end
    end

    def index
        @logged_in = logged_in?
        if (@tag_type = TagType.find_by(id: params[:tag_id]))
            @group_by = @tag_type
            @topics = @tag_type.topics
        elsif (@user = User.find_by(id: params[:user_id]))
            @group_by = @user
            @topics = @user.topics
        elsif (@classroom = Classroom.find_by(id: params[:classroom_id]))
            @group_by = @classroom
            authorize_classroom_entry(@classroom)
            @topics = @classroom.topics
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
            if @topic.classroom.nil?
                redirect_to user_topic_path(current_user, @topic)
            else
                redirect_to classroom_topics_path(@topic.classroom)
            end
        else
            flash[:danger] = "#{@topic.user.name}, there was a problem updating your topict"
            render 'edit'
        end
    end

    def destroy
        @topic = Topic.find(params[:id])
        authorize(@topic.user)
        deleted = @topic.destroy
        flash[:success] = "You successfully deleted your topic"
        if deleted.classroom.nil?
            redirect_to root_path
        else
            redirect_to user_classroom_path(deleted.user, deleted.classroom)
        end
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