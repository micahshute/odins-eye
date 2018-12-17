class AdminController < ApplicationController


    def home
        authorize_admin
        @reported_topics = Topic.reported
        @reported_posts = Post.reported
    end

    def reported_topics
        authorize_admin
        @reported_topics = Topic.reported
    end

    def reported_posts
        authorize_admin
        @reported_posts = Post.reported
    end

    def display_users
        authorize_admin
        @users = User.all
    end

    def destroy_user
        if authorize_admin
            user = User.find(params[:id])
            user.destroy
            flash[:success] = "User successfully destroyed"
            redirect_to admin_home_path
        else
            flash[:danger] = "User failed to delete"
            redirect_to admin_home_path
        end
    end

    def destroy_reports
        if authorize_admin
            Reaction.joins(:reaction_type).where(reaction_types: {id: ReactionType::ID[:report]}).destroy_all
        end
        redirect_to admin_home_path
    end

    def destroy_post
        if authorize_admin
            post = Post.find(params[:id])
            deleted_post = post.destroy
            Notification.create(user: deleted_post.user, content: "Your post to #{deleted_post.topic.title} was deleted by admin because it does not comply with the standards of this site.")
            flash[:success] = "Post successfully destroyed"
            redirect_to admin_home_path
        else
            flash[:danger] = "Post failed to destroy"
            redirect_to admin_home_path
        end
    end

    def destroy_topic
        if authorize_admin
            topic = Topic.find(params[:id])
            deleted_topic = topic.destroy
            Notification.create(user: deleted_topic.user, content: "Your topic #{deleted_topic.title} was deleted by admin because it does not comply with the standards of this site.")
            flash[:success] = "Topic successfully destroyed"
            redirect_to admin_home_path
        else
            flash[:danger] = "Topic failed to destroy"
            redirect_to admin_home_path
        end
    end
end