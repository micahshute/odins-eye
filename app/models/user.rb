class User < ApplicationRecord

    has_secure_password

    #MARK Validations

    validates :name, presence: true
    validates :bio, length: { maximum: 500 }
    validates :email, presence: true, length: { minimum: 5 }
    validates :email, uniqueness: { case_sensitive: false }
    validates :password, length: { in: 8..20 }, on: :create
    validates :password_confirmation, presence: true, on: :create
    validate :email_must_be_valid
    validate :password_requirements, on: :create
    validates :password, length: { in: 8..20 }, if: :setting_password?
    validate :password_requirements, if: :setting_password?

    #must have an @ 
    def email_must_be_valid
        errors.add(:email, "must be valid") unless email.include?(".") and email.include?("@")
    end

    #password must have at least 1 lower case, 1 upper case, and 1 symbol
    def password_requirements
        lowercase = /[a-z]/
        uppercase = /[A-Z]/
        symbols = /[!@#$]/
        invalid = (lowercase.match(self.password).nil? or uppercase.match(self.password).nil? or symbols.match(self.password).nil?)
        errors.add(:password, "must contain required symbols: at least 1 lowercase letter, 1 uppercase letter, and 1 symbol !\#$@") if invalid
    end


    def setting_password?
        password || password_confirmation
    end

    #MARK ActiveRecord Relations

    has_many :posts, dependent: :destroy
    has_many :topics, dependent: :destroy
    has_many :classrooms, dependent: :destroy
    has_many :sent_messages, :class_name => "Message", :foreign_key => "sender_id", dependent: :destroy
    has_many :recieved_messages, :class_name => "Message", :foreign_key => "reciever_id", dependent: :destroy
    has_many :following_users, foreign_key: "follower_id"
    has_many :follower_users, class_name: "FollowingUser", foreign_key: "following_id"
    has_many :followers, class_name: "User", through: :follower_users, foreign_key: "follower_id"
    has_many :following, class_name: "User", through: :following_users, foreign_key: "following_id"
    has_many :reactions, dependent: :destroy
    has_many :reacted_posts, :through => :reactions, :source => :reactable, source_type: 'Post'
    has_many :reacted_topics, through: :reactions, source: :reactable, source_type: "Topic"
    has_many :reaction_types, through: :reactions
    has_many :tags, dependent: :destroy
    has_many :tagged_topics, :through => :tags, source: :taggable, source_type: "Topic"
    has_many :tagged_classrooms, :through => :tags, source: :taggable, source_type: "Classroom"
    has_many :tag_types, through: :tags
    has_many :student_classrooms, dependent: :destroy
    has_many :enrolled_classes, class_name: "Classroom", through: :student_classrooms, source: :classroom
    has_many :user_saved_topics, dependent: :destroy
    has_many :saved_topics, through: :user_saved_topics, source: "topic"


    # MARK Class Methods

    def self.from_google(auth)
        refresh_token = auth.credentials.refresh_token
        if (found_user = User.find_by(email: auth.info.email))
            found_user.google_uid = auth.credentials.token
            found_user.google_refresh_token = refresh_token if refresh_token.present?
            return found_user
        else
            new_user = User.new do |u|
                u.email = auth.info.email
                u.name = auth.info.name
                u.google_uid = auth.credentials.token
                u.google_refresh_token = refresh_token if refresh_token.present?
                rand_password = RandomPasswordStrategy.random_password
                u.password = rand_password
                u.password_confirmation = rand_password
            end
            return new_user
        end
        
    end

    def self.most_followed_count(limit = 5)
        User.joins(:following_users).group(:following_id).order('count(follower_id)').limit(limit).count
    end

    def self.most_followed(limit=5)
        most_followed_count(limit).map{ |user_id, count| User.find(user_id) }
    end 

    # MARK Instance Methods

    def recieved_messages_by_sender
        group_messages_by_sender(self.recieved_messages)
    end

    def sent_messages_by_reciever
        group_messages_by_sender(self.sent_messages)
    end

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

    # MARK: ACTIONS 

    def follow(user)
        self.following << user
    end

    def unfollow(user)
        self.following.delete(user)
    end

    def unseen_notifications
        Notification.unseen_by(self)
    end

    def message(user, content)
        m = Message.create(sender: self, reciever: user, content: content)
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

    def likes?(reactable)
        has_reaction?(reactable, :like)
    end

    def dislikes?(reactable)
        has_reaction?(reactable, :dislike)
    end

    def thinks_is_genius?(reactable)
        has_reaction?(reactable, :genius)
    end

    def reported?(reactable)
        has_reaction?(reactable, :report)
    end

    def likes_for(reactable)
        reaction_for(reactable, :like)
    end

    def dislikes_for(reactable)
        reaction_for(reactable, :dislike)
    end

    def genius_reaction_for(reatable)
        reaction_for(reactable, :genius)
    end

    def reports_for(reactable)
        reaction_for(reactable, :report)
    end

    def most_liked_posts(limit=5)
        Post.most_liked_by_user(self, limit)
    end

    def most_liked_posts_count(limit=5)
        Post.most_liked_count_by_user(self, limit)
    end

    def most_disliked_posts(limit=5)
        Post.most_disliked_by_user(self, limit)
    end

    def most_disliked_posts_count(limit=5)
        Post.most_disliked_count_by_user(self, limit)
    end

    def most_reacted_posts(limit=5)
       Post.most_reacted_by_user(self, limit)
    end

    def most_liked_topics(limit=5)
        Topic.most_liked_by_user(self, limit)
    end

    def most_liked_topics_count(limit=5)
        Topic.most_liked_count_by_user(self, limit)
    end

    def most_disliked_topics(limit=5)
        Topic.most_disliked_by_user(self, limit)
    end

    def most_disliked_topics_count(limit=5)
        Topic.most_disliked_count_by_user(self, limit)
    end

    def most_reacted_topics(limit=5)
       Topic.most_reacted_by_user(self, limit)
    end

    def most_viewed_topics(limit=5)
        Topic.most_viewed_by_user(self, limit)
    end

    def most_viewed_topics_count
        Topic.most_viewed_count_by_user(self, limit)
    end

    private

    def has_reaction?(reactable, type)
        type_id = ReactionType.find_by(name: type).id
        Reaction.joins(:reaction_type).where(reaction_type_id: type_id, user_id: self.id, reactable_id: reactable.id, reactable_type: reactable.class.to_s).length > 0
    end

    def reaction_for(reactable, type)
        type_id = ReactionType.find_by(name: type).id
        Reaction.joins(:reaction_type).where(reaction_type_id: type_id, user_id: self.id, reactable_id: reactable.id, reactable_type: reactable.class.to_s)
    end

    def react(type, reactable)
        reaction_type = ReactionType.find_by!(name: type)
        reaction = Reaction.new(user: self, reaction_type: reaction_type)
        reactable.reactions << reaction
        reactable.save
    end

    def group_messages_by_sender(messages)
        messages_by_sender = {}
        messages.each do |message|
            if messages_by_sender[message.sender].nil?
                messages_by_sender[message.sender] = [message]
            else
                messages_by_sender[message.sender] << messages
            end
        end
        messages_by_sender
    end


end
