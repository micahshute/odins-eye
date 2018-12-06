class TaggableTag < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :user
  belongs_to :tag
end
