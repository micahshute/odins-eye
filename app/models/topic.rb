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

    def public?
        self.classroom.nil?
    end
end
