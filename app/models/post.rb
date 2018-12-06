class Post < ApplicationRecord
  belongs_to :postable, polymorphic: true
  belongs_to :user
  has_many :user_reactions, as: :reactable
  has_many :reactions, through: :user_reactions
  has_many :posts, as: :postable
end
