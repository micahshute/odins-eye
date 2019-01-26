class SerializablePost < JSONAPI::Serializable::Resource
    include SerializeHelpers

    type 'posts'

    attributes :id, :errors, :content, :created_at, :updated_at, :likes, :dislikes, :geniuses

    belongs_to :user
    has_many :posts do
        data do
            @object.posts
        end

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

    attribute :postable do 
        type = @object.postable.class.to_s.downcase
        id = @object.postable.id
         {
            type: type,
            id: id
        }
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

    attribute :post_reply do 
        @object.postable.class.to_s.downcase == "post" 
    end

    attribute :nested_reply do 
        if (@object.postable.class.to_s.downcase == "post" && @object.postable.postable.class.to_s.downcase == "post")
            { author: @object.postable.user.name, author_id: @object.postable.user.id }
        else
            false
        end
    end

    attribute :num_replies do 
        @object.posts.length
    end

    meta do
        { 
            count: @object.class.all.length 
        }
    end
end