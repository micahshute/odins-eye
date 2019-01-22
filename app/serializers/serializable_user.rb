class SerializableUser < JSONAPI::Serializable::Resource

    type 'users'

    attributes :id, :name

    has_many :posts


end