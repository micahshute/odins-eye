class ReactionType < ApplicationRecord
    
    validates :name, presence: true

    has_many :reactions
end
