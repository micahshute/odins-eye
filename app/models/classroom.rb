class Classroom < ApplicationRecord
    
    validates :user_id, presence: true
    validates :name, presence: true
    
    belongs_to :professor, class_name: "User", foreign_key: "user_id"
    has_many :student_classrooms
    has_many :topics
    has_many :tags, as: :taggable
    has_many :users, through: :student_classrooms
    has_many :tag_types, through: :tags

    def self.all_by_tag_name(tag_name)
        Classroom.joins(tag_types: :tags).where(tag_types: {name: tag_name}).group('id')
    end

    def students
        self.users
    end
    
end
