class Post < ApplicationRecord
  belongs_to :postable, polymorphic: true
  belongs_to :user
  has_many :reactions, as: :reactable
  has_many :reaction_types, through: :reactions
  has_many :posts, as: :postable
end
