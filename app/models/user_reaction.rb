class UserReaction < ApplicationRecord
  belongs_to :user
  belongs_to :reaction
  belongs_to :reactable, polymorphic: true
end
