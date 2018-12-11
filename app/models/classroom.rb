class Classroom < ApplicationRecord
    
    validates :user_id, presence: true
    validates :name, presence: true
    
    belongs_to :professor, class_name: "User", foreign_key: "user_id"
    has_many :student_classrooms, dependent: :destroy
    has_many :topics
    has_many :tags, as: :taggable, dependent: :destroy
    has_many :users, through: :student_classrooms
    has_many :tag_types, through: :tags

    def self.all_by_tag_name(tag_name)
        Classroom.joins(tag_types: :tags).where(tag_types: {name: tag_name}).group('id')
    end

    def self.all_public_by_tag_name(tag_name)
        Classroom.joins(tag_types: :tags).where(tag_types: {name: tag_name}, private: false).group('id')
    end

    def self.most_popular(limit=5)
        joins(:student_classrooms).group(:id).order(Arel.sql('count(student_classrooms.user_id) DESC')).limit(limit)
    end

    def self.all_private
        where(private: true)
    end

    def self.all_public
        where(private: false)
    end

    

    def students
        self.users
    end
    
end
