class TopicsController < ApplicationController

    before_action :authorize, only: [:new, :create]

    def new
        @topic = Topic.new
    end

    def create
        @topic = Topic.new(topic_params)
        @topic.user = current_user
        if @topic.save
            flash[:success] = "Congratulations, your topic was published"
            redirect_to user_topic_path(current_user, @topic)
        else
            flash[:danger] = "Oops! There was a problem publishing your post"
            render 'new'
        end
    end

    def show
        @topic = Topic.find(params[:id])
    end

    def edit
        authorize(Topic.find(params[:id]).user)
    end

    def index
        @topic = Topic.all.last
    end

    def update
        authorize(Topic.find(params[:id]).user)
    end

    def destroy
        authorize(Topic.find(params[:id]).user)
    end

    private

    def topic_params
        params.require(:topic).permit([:title, :content])
    end
    
end