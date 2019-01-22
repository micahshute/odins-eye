class PostForm{

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

    get url(){
        let postscript = this.postableType === "topic" ? "posts" : "replies"
        return `/${this.postableType}s/${this.postableId}/${postscript}`
    }

    set url(newURL){
        const parts = newURL.split('/')
        this.postableType = parts[1]
        this.postableId = parts[2]
    }

    get htmlForm(){
        return HandlebarsTemplates['post_form'](this)
    }

    positionPage(){
        let h = 'post-anchor'
        let url = location.href;               
        location.href = "#"+h;                
        history.replaceState(null,null,url);   
    }

    display(){
        let replyContainer
        if(this.postableType === "topic"){
            replyContainer = document.querySelector(`#js-topic-${this.postableId}-reply-container`)
            replyContainer.className = ""
            
        }else{
            replyContainer = document.querySelector(`#js-post-${this.postableId}-reply-container`)
        }
        this.authToken = document.querySelector('[name="authenticity_token"]').value
        replyContainer.innerHTML = this.htmlForm
        this.positionPage()
    }


}