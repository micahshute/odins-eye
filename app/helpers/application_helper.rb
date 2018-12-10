module ApplicationHelper

    def navbar_buttons
        if (user = current_user)
            render 'layouts/logged_in_buttons', user: user
        else
            render 'layouts/logged_out_buttons'
        end
    end

    def likes(reactable, color='dusty-rose')
        render 'components/likes', likes: reactable.likes, color: color
    end

    def dislikes(reactable, color='dusty-rose')
        render 'components/dislikes', dislikes: reactable.dislikes, color: color
    end

    def genius(reactable, color='dusty-rose')
        render 'components/geniuses', geniuses: reactable.geniuses, color: color
    end
    
end
