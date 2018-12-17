
class Topic < ApplicationRecord
    include Reactable
    extend EagerLoading

    # MARK Validations

    validates :title, presence: true, length: { maximum: 50 }
    validates :content, length: { maximum: 100000 }
    validate :validate_tag_number
    validate :classroom_topic_by_professor

    # MARK Validation Methods

    def validate_tag_number
        errors.add(:tags, "you can only have 4 tags") if tags.size > 4
    end

    def classroom_topic_by_professor
        if !!classroom_id
            errors.add(:tags, "Only the classroom professor can write posts") if self.classroom.professor != self.user
        end
    end

    #MARK Activerecord Relations

    belongs_to :user
    belongs_to :classroom, optional: true
    has_many :posts, as: :postable, dependent: :destroy
    has_many :reactions, as: :reactable, dependent: :destroy
    has_many :reaction_types, through: :reactions
    has_many :tags, as: :taggable, dependent: :destroy
    has_many :tag_types, through: :tags
    has_many :user_saved_topics, dependent: :destroy
    has_many :user_saved, through: :user_saved_topics, source: "user"


    before_save :format_content

    accepts_nested_attributes_for :tags, reject_if: ->(tags_attributes){tags_attributes["tag_type_name"].blank? }

    # def tags_attributes=(tags_attributes)
    #     tags_attributes = tags_attributes.values
    #     tags_attributes.each do |tag_attributes|
    #         unless invlaid_attribute?(tag_attributes)
    #             tag = Tag.create(user: self.user)
    #             tag.tag_type_name = tag_attributes[:tag_type_name]
    #             self.tags << tag
    #         end
    #     end
    # end

    def invlaid_attribute?(attributes)
        attributes[:tag_type_name].blank? 
    end


    #MARK Callback Methods

    def format_content
        self.content = self.content.nil? ? "" : self.content.gsub("```", "\n~~~~~")
    end

    #MARK Class Methods

    def self.trending_today
        Topic.joins(:reaction_types).where(reaction_types: {name: ['like', 'genius']}, classroom_id: nil).where(reactions: { created_at: ((Time.now - 24 * 3600)..Time.now)}).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(1)
    end

    def self.all_by_tag_name(tag_name)
        tag_name = format_tag_name(tag_name)
        Topic.joins(tag_types: :tags).where(tag_types: {name: tag_name}).group('id')
    end

    def self.all_public_by_tag_name(tag_name)
        tag_name = format_tag_name(tag_name)
        Topic.joins(tag_types: :tags).where(tag_types: {name: tag_name}, classroom_id: nil).group('id')
    end

    def self.public_by_tag_name(tag_name, limit)
        tag_name = format_tag_name(tag_name)
        Topic.joins(tag_types: :tags).where(tag_types: {name: tag_name}, classroom_id: nil).group('id').limit(limit)
    end

    def self.all_public
        Topic.where(classroom: nil)
    end

    def self.newest_public(limit, offset=0)
        Topic.where(classroom: nil).order(created_at: :desc).limit(limit).offset(offset)
    end

    def self.most_popular
       
    end

    def self.reported
        limit = Topic.all.length
        most_reacted_type('report', limit, false)
    end

    def self.most_geniuses(limit=5)
        most_reacted_type('genius', limit, false)
    end

    def self.most_geniuses_count(limit=5)
        most_reacted_type('genius', limit, true)
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

    def update_views
        update(views: self.views + 1)
    end

    def public?
        self.classroom.nil?
    end

    def tag(*tags)
        tags = *tags.flatten
        tag_types = tags.map do |tag_name|   
            tag_type = TagType.find_or_create_by_name_ignore_case(tag_name.to_s)
            return tag_type if tag_type.errors.any?
            tag_type
        end
        
        tag_types.each do |tag_type|
            if self.new_record?
                Tag.create(tag_type: tag_type, taggable: self) unless ((self.tag_types.length > 0) and self.tag_types.inlcude?(tag_type))
            else
                self.tags.build(tag_type: tag_type) unless self.tag_types.include?(tag_type)
            end
        end
        return self unless self.save
        return true
    end

    def reactions_of_type(type)
        type_id = ReactionType.find_by(name: type).id
        Reaction.joins(:reaction_type).where(reaction_type_id: type_id, reactable_id: self.id, reactable_type: self.class.to_s)
    end

    private

    def self.most_reacted_type(type, limit, count)
        type = type.downcase
        if count
            Topic.joins(:reaction_types).where(reaction_types: {name: type}, classroom_id: nil).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
        else
            Topic.joins(:reaction_types).where(reaction_types: {name: type}, classroom_id: nil).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
        end
    end

    def self.most_reacted_type_and_tag(type, tag, limit, count)
        type = type.downcase
        tag = tag.to_s.gsub(" ","_").downcase
        if count
            Topic.joins(:reaction_types, :tag_types).where(reaction_types: {name: type}, tag_types: {name: tag}, classroom_id: nil).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
        else
            Topic.joins(:reaction_types, :tag_types).where(reaction_types: {name: type}, tag_types: {name: tag}, classroom_id: nil).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
        end
    end

    def self.most_reacted_type_by_user(user, type, limit, count)
        if count
            Topic.joins(:reaction_types).where(reaction_types: {name: type}, user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
        else
            Topic.joins(:reaction_types).where(reaction_types: {name: type}, user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
        end
    end

    def self.format_tag_name(name)
        name.to_s.gsub(" ","_").downcase
    end


   
end
