class Message < ApplicationRecord

    validates :content, presence: true, length: { maximum: 10000 }

    belongs_to :sender, :class_name => "User"
    belongs_to :reciever, :class_name => "User"

end