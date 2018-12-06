class Post < ApplicationRecord

  validates :content, presence: true, length: { maximum: 10000 }

  belongs_to :postable, polymorphic: true
  belongs_to :user
  has_many :reactions, as: :reactable
  has_many :reaction_types, through: :reactions
  has_many :posts, as: :postable

  def self.most_commented

  end

  def self.most_liked

  end

  def self.most_popular

  end

  def self.most_commented_by_tag(tag)

  end

  def self.most_liked_by_tag(tag)

  end

  def self.most_popular_by_tag(tag)

  end
end
