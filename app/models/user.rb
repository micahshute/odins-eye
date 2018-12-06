class User < ApplicationRecord

    has_secure_password

    validates :name, presence: true
    validates :bio, length: { maximum: 500 }
    validates :email, presence: true, length: { minimum: 5 }
    validates :email, uniqueness: { case_sensitive: false }
    validates :password, length: { in: 8..20 }
    validates :password_confirmation, presence: true
    validate :email_must_be_valid
    validate :password_requirements

    #must have an @ 
    def email_must_be_valid
        errors.add(:email, "must be valid") unless email.include?(".") and email.include?("@")
    end

    #password must have at least 1 lower case, 1 upper case, and 1 symbol
    def password_requirements
        lowercase = /[a-z]/
        uppercase = /[A-Z]/
        symbol = /[!@#$%^&*]/
        invalid = lowercase.match(password).nil? or uppercase.match(password).nil? or symbol.match(password).nil?
        errors.add(:password, "must contain required symbols") if invalid
    end


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
    has_many :student_classrooms
    has_many :enrolled_classes, class_name: "Classroom", through: :student_classrooms, source: :classroom

    def most_liked_posts

    end

    def most_liked_topics

    end

    def most_replied_topics

    end

    def most_replied_posts

    end

    def most_viewed_topics

    end

    def most_viewed_posts

    end

    def most_popular_posts

    end

    def most_popular_topics

    end

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
