class WelcomeController < ApplicationController

    def index
        @spotlight = "nil"
        if trending = Topic.trending_today.first
            @spotlight = trending
        else
            @spotlight = Topic.most_likes(1).first
        end

        popular_tags = Tag.most_popular(2)
        @popular_posts_by_tag = {}
        popular_tags.each do |tag|
            @popular_posts_by_tag[tag] = Topic.most_liked_by_tag(tag.name).includes(:posts, :reactions).first || Topic.public_by_tag_name(tag.name, 1).first
        end
        @popular_posts_by_tag = clean_hash(@popular_posts_by_tag)
        offset = params[:offset] || 0
        @recent_topics = Topic.newest_public(5, offset).includes(:posts, :reactions)
        @most_followed_users = User.most_followed(5)
        @most_popular_classrooms = Classroom.most_popular(5)
    end
        
end