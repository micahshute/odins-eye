class PostForm{

    static newFromButton(btn){
        const url = btn.getAttribute('href')
        const form = PostForm.newFromUrl(url)
        form.new = btn.classList.contains("reply-button")
        const container = ElementFunctions.getParentWithClass(btn, 'post-container')
        if(!form.new){
            form.id = container.id.split('-')[1]
            form.getContent()
        }else{
            if(form.postableType === "post"){     
                form.nestedPostReply = !!container.parentElement.previousElementSibling && container.parentElement.previousElementSibling.classList.contains('col-sm-1')
                if(form.nestedPostReply && form.new){
                    const userLink = ElementFunctions.getChildWithType(container, "a")
                    const userName = userLink.textContent
                    const userId = userLink.getAttribute('href').split('/')[userLink.getAttribute('href').split('/').length - 1]
                    const user = new User(userId, userName)
                    form.user = user
                    form.content = `[${form.user.name}](${form.user.path})`
                } 
            }
        }
        return form
    }

    static newFromUrl(url){
        const urlParts = url.split('/')
        const type = urlParts[urlParts.length - 1].split('#')[0]
        const data = {
            postableType: urlParts[1].slice(0,-1),
            postableId: urlParts[2],
            errors: {
                exist: false,
                content: null
            },
            content: null,
            newPost: (type === "new"),
        }
        return new PostForm(data)
    }


    constructor(data){
        this.postableType = data.postableType.toLowerCase()
        this.postableId = data.postableId
        this.errors = data.errors
        this.content = data.content
        this.method = data.newPost ? "post" : "patch"
        this.type = data.newPost ? "new" : "edit"
        this.submitButton = data.newPost ? "Add Post" : "Update"
    }

    getContent(){
        const req = new JSONRequestManager(`/posts/${this.id}`)
        req.comm()
        .success(data => {
            console.log(data)
            this.content = data.data.attributes.markdown_content
            this.display()
        })
        .error(err => {
            const flashMessage = new FlashMessage('danger', err)
            const flashTemplate = HandlebarsTemplates['flash_message'](flashMessage)
            const contentDiv = document.querySelector('#flash-message')
            contentDiv.innerHTML = flashTemplate
        })
        
    }

    get newUrl(){
        let postscript = this.postableType === "topic" ? "posts" : "replies"
        return `/${this.postableType}s/${this.postableId}/${postscript}`
    }

    get editUrl(){
        return `${this.newUrl}/${this.id}`
    }

    get url(){
        return this.new ? this.newUrl : this.editUrl
    }

    set url(newURL){
        const parts = newURL.split('/')
        this.postableType = parts[1]
        this.postableId = parts[2]
    }

    get htmlForm(){
        return HandlebarsTemplates['post_form'](this)
    }

    // positionPage(){
    //     let h = 'post-anchor'
    //     let url = location.href;               
    //     location.href = "#"+h;                
    //     history.replaceState(null,null,url);   
    // }

    display(){
        let replyContainer
        if(this.new){
            if(this.postableType === "topic"){
                //form for replying to a topic will replace the Topic reply button
                replyContainer = document.querySelector(`#js-topic-${this.postableId}-reply-button`)
                replyContainer.className = ""   
            }else{
                //for for replying to a post will go below the post in the reply container
                replyContainer = document.querySelector(`#js-post-${this.postableId}-reply-container`)
            }
        }else{
            //when editing a post, the replyContainer will replace the post itself
            replyContainer = document.querySelector(`#post-${this.id}`).parentElement.parentElement
            //when editing the post, the empty reply container will create a duplicate id and must be deleted

            let duplicate = document.querySelector(`#js-post-${this.id}-reply-container`)
            if(!!duplicate) duplicate.remove()

            replyContainer.id = `js-post-${this.id}-reply-container`
            replyContainer.removeAttribute('class')
        }
        
        this.authToken = document.querySelector('[name="authenticity_token"]').value
        replyContainer.innerHTML = this.htmlForm
    }

}