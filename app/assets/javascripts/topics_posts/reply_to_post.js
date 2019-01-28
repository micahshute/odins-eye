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

async function submitPost(e){
    const url = e.getAttribute('action');
    const method = e.getAttribute('method');
    const req = new JSONRequestManager(url, {method: method, form: e})
    
    try{
        const data = await req.afetch()
        // data.data.attributes = {...data.data.attributes, owned: true, loggedIn: true, liked: false, disliked: false, geniused: false}
        const post = new Post(data)
        await post.fetchUserData()
        post.render()
    }catch(e){
        const flash = new FlashMessage('danger', e)
        flash.render()
    }

}