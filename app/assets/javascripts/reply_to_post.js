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
            const form = PostForm.newFromReplyButton(link)
            console.log(form)
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
        const post = new Post(data)
        console.log(post.html)
        post.render()

    })
    .error((err) => {
        console.log(err)
    })
}