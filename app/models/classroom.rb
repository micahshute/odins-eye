class Classroom < ApplicationRecord
    
    validates :user_id, presence: true
    validates :name, presence: true
    
    belongs_to :professor, class_name: "User", foreign_key: "user_id"
    has_many :student_classrooms, dependent: :destroy
    has_many :topics, dependent: :destroy
    has_many :tags, as: :taggable, dependent: :destroy
    has_many :users, through: :student_classrooms
    has_many :tag_types, through: :tags

    accepts_nested_attributes_for :tags, reject_if: ->(tags_attributes){tags_attributes["tag_type_name"].blank? }

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
        where(private: true).order(created_at: :desc)
    end

    def self.all_public
        where(private: false).order(created_at: :desc)
    end

    def self.by_tag(tag_name)
        tag_type = TagType.find_by(name: tag_name)
        return [] if tag_type.nil?
        joins(:tag_types).where(tag_types: {id: tag_type.id})
    end
    

    def students
        self.users
    end

    def enroll(user)
        self.users << user
    end
    
end
