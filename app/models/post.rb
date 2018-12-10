class Post < ApplicationRecord
  include Reactable
  
  validates :content, presence: true, length: { maximum: 10000 }

  belongs_to :postable, polymorphic: true
  belongs_to :user
  has_many :reactions, as: :reactable
  has_many :reaction_types, through: :reactions
  has_many :posts, as: :postable

  def self.most_liked_count(limit = 5)
    most_reacted_type('like', limit, true)
  end

  def self.most_liked(limit = 5)
    most_reacted_type('like', limit, false)
  end

  def self.most_dislikes_count(limit=5)
    most_reacted_type('dislike', limit, true)
  end

  def self.most_dislikes(limit=5)
    most_reacted_type('dislike', limit, false)
  end

  def self.most_reacted(limit = 5)
    Post.joins(:reaction_types).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
  end

  def self.most_liked_by_user(user, limit=5)
    most_reacted_type_by_user(user, 'like', limit, false)
  end

  def self.most_liked_count_by_user(user, limit=5)
    most_reacted_type_by_user(user, 'like', limit, true)
  end

  def self.most_disliked_by_user(user, limit=5)
    most_reacted_type_by_user(user, 'dislike', limit, false)
  end

  def self.most_disliked_count(user, limit=5)
    most_reacted_type_by_user(user, 'dislike', limit, true)
  end

  def self.most_reacted_by_user(user, limit=5)
    Post.joins(:reaction_types).where(user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
  end



  private

  def self.most_reacted_type(type, limit, count)
    if count
      Post.joins(:reaction_types).where(reaction_types: {name: type}).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
    else
      Post.joins(:reaction_types).where(reaction_types: {name: type}).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
    end
  end

  def self.most_reacted_type_by_user(user, type, limit, count)
    if count
      Post.joins(:reaction_types).where(reaction_types: {name: type}, user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit).count
    else
      Post.joins(:reaction_types).where(reaction_types: {name: type}, user_id: user.id).group('id').order(Arel.sql('count(reaction_type_id) DESC')).limit(limit)
    end
  end


end
