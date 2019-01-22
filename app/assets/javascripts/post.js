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
        return document.querySelector(`#js-${this.postable.type}-reply-container`)
    }

    replaceForm(){
        console.log(`${this.postable.type}, ${this.postable.id}`)
        
        this.container.innerHTML = this.html
        this.container.className = "row"
        this.container.removeAttribute("id")
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