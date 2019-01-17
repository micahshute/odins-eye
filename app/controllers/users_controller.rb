class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(new_user_params)
        if @user.save
            log_in(@user)
            flash[:success] = "Welcome #{@user.name}!"
            redirect_to dashboard_path
        else
            flash[:danger] = "Oops! There was trouble making your acount."
            render 'new'
        end
    end

    def show
        @user = User.find(params[:id])
        @logged_in = logged_in?
    end

    def edit
        @user = User.find(params[:id])
        authorize(@user)
    end

    def update
        @user = User.find(params[:id])
        authorize(@user)
        if @user.update(user_params(:bio, :image_path, :github_url, :facebook_url, :linkedin_url, :name))
            redirect_to user_path(@user)
        else
            render 'new'
        end

    end

    def dashboard
        if authorize
            @user = current_user
        end
    end

    def following
        if authorize
            @user = current_user
            @following = @user.following
        end
    end

    def followers
        if authorize
            @user = current_user
            @followers = @user.followers
        end
    end

    def follow
        if authorize
            auth_user = current_user
            user_to_follow = User.find(params[:id])
            if auth_user == user_to_follow
                flash[:danger] = "You cannot follow yourself"
                redirect_to last_page
            elsif auth_user.following?(user_to_follow)
                user_to_follow.followers.delete(auth_user)
                redirect_to last_page
            else
                auth_user.follow(user_to_follow)
                create_notification(user_to_follow, "#{auth_user.name} is following you!")
                redirect_to last_page
            end
        end
    end


    def reading_list_create
        if authorize
            user = current_user
            if(topic = Topic.find(params[:topic_id]))
                if user.topic_saved?(topic)
                    user.saved_topics.delete(topic)
                else
                    user.save_topic(topic)
                end
                redirect_to request.referer
            else
                flash[:danger] = "There was a problem saving this post, please contact a system Admin"
                redirect_to request.referer
            end
        end
    end


    private

    def user_params(*args)
        params.require(:user).permit(*args)
    end

    def new_user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def create_notification(user, msg = "")
        Notification.create(user: user, content: msg)
    end
end