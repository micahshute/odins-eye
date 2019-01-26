class SerializableTopic < JSONAPI::Serializable::Resource
    include SerializeHelpers

    type 'topics'

    attributes :id, :title, :errors, :created_at, :updated_at, :likes, :dislikes, :geniuses, :views

    belongs_to :user do
        data do 
           @object.user
        end

        meta do 
            {
                name: @object.user.name,
                id: @object.user.id
            }
        end
    end

    has_many :posts do

        meta do 
            { count: @object.posts.length }
        end
    end

    attribute :content do 
        markdown = Kramdown::Document.new(@object.content, parse_block_html: true, syntax_highlighter: :rouge, syntax_highlighter_opts: {line_numbers: false}).to_html
        ActionController::Base.helpers.sanitize(markdown, tags:  Loofah::HTML5::WhiteList::ALLOWED_ELEMENTS_WITH_LIBXML2.to_a + %w(table th td tr span), attibutes: Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES + %w( style ))
    end

    attribute :markdown_content do 
        @object.content
    end


    attribute :post_time do
        time_from_now(@object.created_at)
    end

    attribute :edit_time do 
        time_from_now(@object.updated_at)
    end

    attribute :edited do 
        @object.updated_at > @object.created_at
    end

    attribute :created_display do
        display_date_long(@object.created_at)
    end

    attribute :edited_display do 
        display_date_long(@object.updated_at)
    end

    attribute :author do
        @object.user.name
    end

    attribute :author_id do
        @object.user.id
    end


    meta do
        {   
            count: @object.class.all_public.length,
            total_count: @object.class.all.length,
            tags: @object.tags.map{ |tag| tag.tag_type.name } 
        }
    end
    

end