class Tag < ApplicationRecord
    has_many :taggable_tags
end
