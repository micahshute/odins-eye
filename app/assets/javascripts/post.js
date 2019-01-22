class Post{

    constructor(data){
        for(let attr in data.data.attributes){
            this[attr] = data.data.attributes[attr]
        }
        
        const userAttributes = data.included[0].attributes
        this.author = new User(userAttributes.id, userAttributes.name)
    }

    get html(){
        return HandlebarsTemplates['posts/post'](this)
    }

    get element(){
        return document.querySelector(`#post-${this.id}`)
    }

    get container(){
        return document.querySelector(`#js-${this.postable.type}-${this.postable.id}-reply-container`)
    }

    replaceForm(){
        let container = this.container
        container.innerHTML = this.html
        container.className = "row"
        container.removeAttribute("id")
        container.insertAdjacentHTML('afterend', `<div id="js-post-${this.id}-reply-container"></div>`)
        if(this.postable.type === "topic"){
            this.replaceReplyButton()
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

}