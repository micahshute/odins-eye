document.addEventListener('DOMContentLoaded', function(){
    addReplyButtonEventListener()
})

function isReplyButton(e){
    return e.classList.contains("reply-button")
}

function addReplyButtonEventListener(){
    document.addEventListener('click', function(e){
        const link = ElementFunctions.getParentLinkFromClick(e)
        if(isReplyButton(link)){
            e.preventDefault()
            const form = PostForm.newFromButton(link)
            form.display()
        }
    })  
}

function submitPost(e){
    const url = e.getAttribute('action');
    const method = e.getAttribute('method');
    const req = new JSONRequestManager(url, {method: method, form: e})
    console.log(req)
    req.comm()
    .success((data) => {
        console.log(data)
        data.data.attributes = {...data.data.attributes, owned: true, loggedIn: true, liked: false, disliked: false, geniused: false}
        console.log(data)
        const post = new Post(data)
        console.log(post)
        post.render()

    })
    .error((err) => {
        const flashMessage = new FlashMessage('danger', err)
        const flashTemplate = HandlebarsTemplates['flash_message'](flashMessage)
        const contentDiv = document.querySelector('#flash-message')
        contentDiv.innerHTML = flashTemplate
    })
}