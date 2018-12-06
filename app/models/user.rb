class User < ApplicationRecord
    has_secure_password

    has_many :posts
    has_many :topics
    has_many :classrooms
    has_many :sent_messages, :class_name => "Message", :foreign_key => "sender_id"
    has_many :recieved_messages, :class_name => "Message", :foreign_key => "reciever_id"
    has_many :following_users, foreign_key: "follower_id"
    has_many :follower_users, class_name: "FollowingUser", foreign_key: "following_id"
    has_many :followers, class_name: "User", through: :follower_users, foreign_key: "follower_id"
    has_many :following, class_name: "User", through: :following_users, foreign_key: "following_id"
    has_many :reactions
    has_many :reacted_posts, :through => :reactions, :source => :reactable, source_type: 'Post'
    has_many :reacted_topics, through: :reactions, source: :reactable, source_type: "Topic"
    has_many :reaction_types, through: :reactions
    has_many :tags
    has_many :tagged_topics, :through => :tags, source: :taggable, source_type: "Topic"
    has_many :tagged_classrooms, :through => :tags, source: :taggable, source_type: "Classroom"
    has_many :tag_types, through: :tags
    
    def message(user, content)
        Message.create(sender: self, reciever: user, content: content)
    end

    def like(reactable)
        react("like", reactable)
    end

    def dislike(reactable)
        react("dislike", reactable)
    end

    def report(reactable)
        react("report", reactable)
    end

    def is_genius(reactable)
        react("genius", reactable)
    end

    private

    def react(type, reactable)
        reaction_type = ReactionType.find_by!(name: type)
        reaction = Reaction.new(user: self, reaction_type: reaction_type)
        reactable.reactions << reaction
        reactable.save
    end
end
