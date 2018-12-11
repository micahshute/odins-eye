class TagType < ApplicationRecord

    validates :name, presence: true
    validates :name, uniqueness: true
    validates :name, length: { maximum: 17 }

    before_save :format_name
   

    has_many :tags, dependent: :destroy


    # MARK Callbacks

    def format_name
        self.name = self.class.format_name(self.name)
    end
        

    # MARK Class Methods

    def self.find_or_create_by_name_ignore_case(name)
        name = format_name(name)
        TagType.where('lower(name) = ?', name).first_or_create(name: name)
    end

    def self.format_name(name)
        regex = /[\w_]+/
        name.gsub(" ", "_").downcase.match(regex).to_s
    end
end
