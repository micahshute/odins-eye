module ApplicationHelper

    def navbar_buttons
        if (user = current_user)
            render 'layouts/logged_in_buttons', user: user
        else
            render 'layouts/logged_out_buttons'
        end
    end


    def render_markdown(markdown)
        render 'components/content', markdown: Kramdown::Document.new(markdown, parse_block_html: true, syntax_highlighter: :rouge, syntax_highlighter_opts: {line_numbers: false}).to_html
    end

    def likes(reactable, img_color='dusty-rose', text_color='charcoal')
        render 'components/likes', likes: reactable.likes, img_color: img_color, text_color: text_color
    end

    def dislikes(reactable, img_color='dusty-rose', text_color='charcoal')
        render 'components/dislikes', dislikes: reactable.dislikes, img_color: img_color, text_color: text_color
    end

    def genius(reactable, img_color='dusty-rose', text_color='charcoal')
        render 'components/geniuses', geniuses: reactable.geniuses, img_color: img_color, text_color: text_color
    end

    def save_topic_button(topic, saved_color="aqua", img_color='charcoal')
        render 'components/save_topic', topic: topic, saved_color: saved_color, img_color: img_color
    end

    def edit_button(edit_path, img_color="charcoal")
        render 'components/edit', edit_path: edit_path, img_color: img_color
    end

    def edit_text_button(edit_path, color="aqua")
        render 'components/edit_text', edit_path: edit_path, color: color
    end

    def delete_text_button(delete_path, color="aqua")
        render 'components/delete_text', delete_path: delete_path, color: color
    end

    def delete_button(delete_path, img_color="charcoal")
        render 'components/delete', delete_path: delete_path, img_color: img_color
    end

    def sanitize_markdown(content)
        sanitize(content, tags:  Loofah::HTML5::WhiteList::ALLOWED_ELEMENTS_WITH_LIBXML2.to_a + %w(table th td tr span), attibutes: Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES + %w( style ))
    end
    
end
