class SerializableReaction < JSONAPI::Serializable::Resource
    type 'reactions'
    attributes :id, :user_id, :reactable_type, :reactable_id, :reaction_type_id, :created_at, :updated_at

    attribute :reaction_type do 
        @object.reaction_type.name
    end

end