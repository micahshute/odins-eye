class Topic < ApplicationRecord
    belongs_to :user
    belongs_to :classroom, optional: true
    has_many :posts, as: :postable
    has_many :user_reactions, as: :reactable
    has_many :reactions, through: :user_reactions
    has_many :taggable_tags, as: :taggable
    has_many :tags, through: :taggable_tags

    def public?
        self.classroom.nil?
    end
end
