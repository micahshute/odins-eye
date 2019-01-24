class SerializableUser < JSONAPI::Serializable::Resource

    type 'users'

    attributes :id, :name, :email

    has_many :posts


end