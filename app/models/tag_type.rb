class TagType < ApplicationRecord

    validates :name, presence: true
    validates :name, uniqueness: true


    before_save :remove_spaces
    before_save :downcase_fields
   

    has_many :tags, dependent: :destroy


    # MARK Callbacks

    def downcase_fields
        self.name = self.name.downcase
    end

    def remove_spaces
        self.name = self.name.gsub(" ", "_")
    end
        

    # MARK Class Methods

    def self.find_or_create_by_name_ignore_case(name)
        name = name.gsub(" ", "_").downcase
        TagType.where('lower(name) = ?', name).first_or_create(name: name)
    end
end
