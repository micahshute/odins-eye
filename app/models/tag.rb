class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :user
  belongs_to :tag_type

  before_destroy :check_if_last

  # MARK Callbacks

  def check_if_last
    if self.class.where(tag_type_id: self.tag_type_id).count == 0
      TagType.find(self.tag_type_id).destroy
    end
  end


  # MARK Class Methods

  def self.most_popular_count(limit=5)
    Tag.joins(:tag_type).group(:tag_type_id).limit(limit).count
  end

  def self.most_popular(limit=5)
    self.most_popular_count(limit).map{|id, count| TagType.find(id) }
  end


end
