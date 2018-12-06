class Classroom < ApplicationRecord
    belongs_to :professor, class_name: "User", foreign_key: "user_id"
    has_many :student_classrooms
    has_many :topics
    has_many :tags
    has_many :users, through: :student_classrooms

    def students
        self.users
    end
end
