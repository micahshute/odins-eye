class Topic < ApplicationRecord

    validates :content, presence: true, length: { maximum: 10000 }

    belongs_to :user
    belongs_to :classroom, optional: true
    has_many :posts, as: :postable
    has_many :reactions, as: :reactable
    has_many :reaction_types, through: :reactions
    has_many :tags, as: :taggable
    has_many :tag_types, through: :tags

    def self.all_by_tag_name(tag_name)
        Topic.joins(tag_types: :tags).where(tag_types: {name: tag_name}).group('id')
    end

    def self.all_public_by_tag_name(tag_name)
        Topic.joins(tag_types: :tags).where(tag_types: {name: tag_name}, classroom_id: nil).group('id')
    end

    def self.all_public
        Topic.where(classroom: nil)
    end

    def self.most_likes(limit = 5)
        most_reacted_type('like', limit, false)
    end

    def self.most_likes_count(limit = 5)
        most_reacted_type('like', limit, true)
    end

    def self.most_dislikes(limit=5)
        most_reacted_type('dislike', limit, false)
    end

    def self.most_dislikes_count(limit=5)
        most_reacted_type('dislike', limit, true)
    end

    def self.most_reactions
        Post.joins(:reaction_types).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
    end

    def self.most_reactions_count
        Post.joins(:reaction_types).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
    end

    def self.most_viewed(limit=5)
        Topic.order('count(views) DESC').group('id').limit(limit)
    end

    def self.most_viewed_count(limit=5)
        Topic.order('count(views) DESC').group('id').limit(limit).count
    end

    def self.most_liked_by_tag(tag, limit=5)
        most_reacted_type_and_tag('like', tag, limit, false)
    end

 

    def self.most_liked_by_user(user, limit=5)
       most_reacted_type_by_user(user, 'like', limit, false)
    end
    
    def self.most_liked_count_by_user(user, limit=5)
        most_reacted_type_by_user(user, 'like', limit, true)
    end
   
    def self.most_disliked_by_user(user, limit=5)
        most_reacted_type_by_user(user, 'dislike', limit, false)
     end
     
     def self.most_disliked_count_by_user(user, limit=5)
         most_reacted_type_by_user(user, 'dislike', limit, true)
     end

    def self.most_reacted_by_user(user, limit=5)
        Topic.joins(:reaction_types).where(user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
    end

    def self.most_reacted_count_by_user(user, limit=5)
        Topic.joins(:reaction_types).where(user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
    end

    def self.most_viewed_by_user(user, limit=5)
        Topic.where(user_id: user.id).order(Arel.sql('count(views) DESC')).group('id').limit(limit)
    end

    def self.most_viewed_count_by_user(user, limit=5)
        Topic.where(user_id: user.id).order(Arel.sql('count(views) DESC')).group('id').limit(limit).count
    end

    #MARK Instance Methods

    def public?
        self.classroom.nil?
    end


    private

    def self.most_reacted_type(type, limit, count)
        if count
            Topic.joins(:reaction_types).where(reaction_types: {name: type}).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
        else
            Topic.joins(:reaction_types).where(reaction_types: {name: type}).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
        end
    end

    def self.most_reacted_type_and_tag(type, tag, limit, count)
        if count
            Topic.joins(:reaction_types, :tag_types).where(reaction_types: {name: type}, tag_types: {name: tag}).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
        else
            Topic.joins(:reaction_types, :tag_types).where(reaction_types: {name: type}, tag_types: {name: tag}).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
        end
    end

    def self.most_reacted_type_by_user(user, type, limit, count)
        if count
            Topic.joins(:reaction_types).where(reaction_types: {name: type}, user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
        else
            Topic.joins(:reaction_types).where(reaction_types: {name: type}, user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
        end
    end
end
