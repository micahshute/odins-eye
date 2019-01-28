class Post{

    constructor(data){
        for(let attr in data.data.attributes){
            this[attr] = data.data.attributes[attr]
        }
        let userAttributes
        if(data.included.length > 1){
            const userId = data.data.relationships.user.data.id
            const attributes = data.included
            for(let att of attributes){
                if(att.attributes.id === userId){
                    userAttributes = att.attributes
                }
            }

        }
        userAttributes = data.included[0].attributes
        this.author = new User(userAttributes.id, userAttributes.name)
        this.selectedColor = 'aqua'
        this.unselectedColor = 'charcoal'
    }

    get html(){
        return HandlebarsTemplates['posts/post'](this)
    }

    get htmlInRow(){
        return `<div class="row">${this.html}</div>`
    }

    get viewRepliesButtonHTML(){
        const buttonInfo = {
            replies_phrase: Functions.pluralize(this.num_replies, "Reply"),
            id: this.id
        }
        return HandlebarsTemplates['posts/view_replies_button'](buttonInfo)
    }

    get fullHtml(){
        let buttonHTML = ''
        if(this.num_replies > 0 && !this.post_reply){
            buttonHTML = this.viewRepliesButtonHTML
        }
        return `${this.htmlInRow}<div id="js-post-${this.id}-reply-container"></div>${buttonHTML}`
    }

    get element(){
        return document.querySelector(`#post-${this.id}`)
    }

    get newTopicContainer(){
        const replyContainer = document.querySelector('.js-topic-replies')
        const newTopicContainer = document.createElement('div')
        replyContainer.insertAdjacentElement('afterbegin', newTopicContainer)
        document.querySelector(`#js-${this.postable.type}-${this.postable.id}-reply-button`).remove()
        return newTopicContainer
    }

    get newPostContainer(){
        return document.querySelector(`#js-${this.postable.type}-${this.postable.id}-reply-container`)
    }

    get editedContainer(){
        return document.querySelector(`#js-post-${this.id}-reply-container`)
    }

    async fetchUserData(){
        try{
            const currentUser = await CurrentUser.data()
            const reactions = await CurrentUser.reactionsForPost(this.id)
            if(currentUser.data !== null){
                this.loggedIn = true
                this.liked = reactions.data.like
                this.disliked = reactions.data.dislike
                this.geniused = reactions.data.genius
                this.owned = parseInt(currentUser.data.attributes.id) === parseInt(this.author.id)
            }else{
                this.loggedIn = false
                this.liked = false
                this.dislike = false
                this.geniused = false
                this.owned = false
            }
        }catch(e){
            const flash = new FlashMessage('danger', e)
            flash.render()
        }
    }

    replaceForm(){
        // the new form will replace the post itself
        let container 
        if(this.edited){
            container = this.editedContainer
        }else{
            container = this.postable.type === "post" ? this.newPostContainer : this.newTopicContainer
        }
        // the id of the form will say if it is a new or edited post. This will determine whether
        // we need to replace the topic reply button (below). In every case the post will replace the form
        let form = ElementFunctions.getChildWithType(container, 'form')
        let editPost = form && (form.id === "edit-post")
        container.innerHTML = this.html
        container.className = "row"
        container.removeAttribute("id")
        container.insertAdjacentHTML('afterend', `<div id="js-post-${this.id}-reply-container"></div>`)
        if(this.postable.type === "topic" && !editPost){
            this.replaceReplyButton()
        }
        if(this.postable.type === "post" && !editPost){
            container.insertAdjacentHTML('beforebegin', `<div id="js-post-${this.postable.id}-reply-container"></div>`)
        }

    }

    replaceReplyButton(){
        const topicEl = document.querySelector('.js-topic-container')
        const html = HandlebarsTemplates['posts/topic_reply_button']({id: this.postable.id})
        topicEl.insertAdjacentHTML('afterend', html)
    }

    render(){
        this.replaceForm()
    }

    displayAtBottom(){
        const replyButton = document.querySelector('.topic-reply').parentElement.parentElement
        replyButton.insertAdjacentHTML('afterend', this.fullHtml)
    }

}