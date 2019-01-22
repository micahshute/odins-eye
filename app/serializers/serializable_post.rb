class SerializablePost < JSONAPI::Serializable::Resource

    type 'posts'

    attributes :id, :errors, :content, :created_at, :updated_at, :likes, :dislikes, :geniuses

    belongs_to :user

    attribute :content do 
        markdown = Kramdown::Document.new(@object.content, parse_block_html: true, syntax_highlighter: :rouge, syntax_highlighter_opts: {line_numbers: false}).to_html
        ActionController::Base.helpers.sanitize(markdown, tags:  Loofah::HTML5::WhiteList::ALLOWED_ELEMENTS_WITH_LIBXML2.to_a + %w(table th td tr span), attibutes: Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES + %w( style ))
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

    
    def time_from_now(time)
        seconds = Time.now - time
        if seconds < 60
            return "#{seconds.to_i} seconds ago"
        elsif seconds < 3600
            return "#{(seconds / 60.0).to_i} minutes ago"
        elsif seconds < 86400
            return "#{(seconds / 3600.0).to_i} hours ago"
        elsif seconds < 604800
            return "#{(seconds / 86400.0).to_i} days ago"
        elsif seconds < 2419200
            return "#{(seconds / 604800.0).to_i} weeks ago"
        else
            return "on #{time}"
        end

    end

end