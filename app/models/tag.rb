
class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag_type

  after_destroy :check_if_last

  # MARK Callbacks

  def check_if_last
    if self.class.where(tag_type_id: self.tag_type_id).count == 0
      TagType.find(self.tag_type_id).destroy
    end
  end

  #MARK Validations

  validate :no_duplicates
  after_save :remove_duplicates

  def remove_duplicates
    duplicates = Tag.where(taggable_id: self.taggable_id, taggable_type: self.taggable_type, tag_type_id: self.tag_type_id)
    self.destroy if duplicates.length > 1
  end

  def no_duplicates
    if !self.taggable_id.nil?
      duplicates = Tag.where(taggable_id: self.taggable_id, taggable_type: self.taggable_type, tag_type_id: self.tag_type_id)
      errors.add(:tag_type_id, "You cannot have duplicate tags") if duplicates.length > 0
      # byebug
    end
  end

  # MARK Class Methods

  def self.most_popular_count(limit=5)
    Tag.joins(:tag_type).group(:tag_type_id).limit(limit).count
  end

  def self.most_popular(limit=5)
    self.most_popular_count(limit).map{|id, count| TagType.find(id) }
  end

  # MARK Instance Methods

  def tag_type_name
    self.tag_type.nil? ? nil : self.tag_type.name
  end

  def tag_type_name=(name)
    self.tag_type = TagType.find_or_create_by_name_ignore_case(name)
  end

end
