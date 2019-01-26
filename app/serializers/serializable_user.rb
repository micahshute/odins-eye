class SerializableUser < JSONAPI::Serializable::Resource

    type 'users'

    attributes :id, :name, :email
    has_many :topics
    has_many :posts

    
end