class Post < ApplicationRecord

  validates :content, presence: true, length: { maximum: 10000 }

  belongs_to :postable, polymorphic: true
  belongs_to :user
  has_many :reactions, as: :reactable
  has_many :reaction_types, through: :reactions
  has_many :posts, as: :postable
end
