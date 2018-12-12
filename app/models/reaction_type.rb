class ReactionType < ApplicationRecord
    
    validates :name, presence: true
    validates :name, uniqueness: true
    has_many :reactions, dependent: :destroy

    ID = {
        like: 1,
        dislike: 2,
        genius: 3,
        report: 4
    }
end
