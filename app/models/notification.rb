class Notification < ApplicationRecord

    validates :content, presence: true
    belongs_to :user
    


    def unseen_by(user)
        Notification.where(user_id: user.id, viewed: false)
    end

end
