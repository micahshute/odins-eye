class ReactionType < ApplicationRecord
    
    validates :name, presence: true
    validates :name, uniqueness: true
    has_many :reactions, dependent: :destroy
end
