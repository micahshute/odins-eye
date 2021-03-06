class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reaction_type
  belongs_to :reactable, polymorphic: true

  validates :user_id, presence: true
  validates :reaction_type_id, presence: true
  validate :no_incompatible_types

  before_validation :replace_incompatible_types

  def no_incompatible_types
    if self.reaction_type.name == 'dislike'
      errors.add(:reaction_type, "cannot have incosistent reactions") if (self.user.likes?(self.reactable) or self.user.thinks_is_genius?(self.reactable))
      errors.add(:reaction_type, "cannot have duplicate reactions") if user.dislikes?(self.reactable)
    elsif (self.reaction_type.name == 'like') 
      errors.add(:reaction_type, "cannot have incosistent reactions") if (self.user.dislikes?(self.reactable))
      errors.add(:reaction_type, "cannot have duplicate reactions") if user.likes?(self.reactable)
    elsif self.reaction_type.name == 'genius'
      errors.add(:reaction_type, "cannot have incosistent reactions") if (self.user.dislikes?(self.reactable))
      errors.add(:reaction_type, "cannot have duplicate reactions") if user.thinks_is_genius?(self.reactable)
    elsif self.reaction_type.name == 'report'
      errors.add(:reaction_type, "You have already reported this post") if user.reported?(self.reactable)
    end
  end

  def replace_incompatible_types
    reactions_to_reactable = self.class.user_reactable(self.user, self.reactable)
    type_ids = {}
    ReactionType.all.each{ |rt| type_ids[rt.name.to_sym] = rt.id}
    case self.reaction_type.name
    when "like"
      dislikes = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:dislike] }
      likes = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:like]}
      dislikes.each(&:destroy)
      likes.each(&:destroy)
    when 'dislike'
      dislikes = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:dislike] }
      likes = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:like]}
      geniuses = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:genius] } 
      geniuses.each(&:destroy)
      dislikes.each(&:destroy)
      likes.each(&:destroy)
    when 'genius'
      dislikes = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:dislike] }
      geniuses = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:genius] } 
      dislikes.each(&:destroy)
      geniuses.each(&:destroy)
    when 'report'
      likes = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:like]}
      geniuses = reactions_to_reactable.select{ |reaction| reaction.reaction_type_id == type_ids[:genius] } 
      likes.each(&:destroy)
      geniuses.each(&:destroy)
    end
  end


  def self.user_reactable_by_type(user, reactable, type)
    type_id = ReactionType.find_by(name: type).id
    where(user_id: user.id, reactable_id: reactable.id, reactable_type: reactable.class.to_s, reaction_type_id: type_id)
  end

  def self.user_reactable(user, reactable)
    where(user_id: user.id, reactable_id: reactable.id, reactable_type: reactable.class.to_s)
  end

end
