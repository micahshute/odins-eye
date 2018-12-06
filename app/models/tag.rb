class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :user
  belongs_to :tag_type

  def self.most_topics

  end

  def self.most_popular

  end
  
end
