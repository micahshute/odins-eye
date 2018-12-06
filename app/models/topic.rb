class Topic < ApplicationRecord
    belongs_to :user
    belongs_to :classroom, optional: true
    has_many :posts, as: :postable
    has_many :reactions, as: :reactable
    has_many :reaction_types, through: :reactions
    has_many :tags, as: :taggable
    has_many :tag_typess, through: :tags

    def public?
        self.classroom.nil?
    end
end
