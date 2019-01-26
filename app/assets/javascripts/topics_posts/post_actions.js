document.addEventListener('DOMContentLoaded', function(){
    addPostActionEventListeners()
})

function isReportButton(el){
    return (el.tagName === "A" && el.textContent == "Report this post")
}

function isDeleteButton(el){
    return (el.tagName === "A" && el.textContent == "Delete")
}

function isEditButton(el){
    return (el.tagName === "A" && el.textContent == "Edit" && !!ElementFunctions.getParentWithClass(el, 'post-container'))
}


function addPostActionEventListeners(){
    document.addEventListener('click', function(e){
        const link = ElementFunctions.getParentLinkFromClick(e)
        if(isEditButton(link)){
            e.preventDefault()
            PostForm.newFromButton(link)

        }else if(isDeleteButton(link)){
            e.preventDefault()
            let postContainer = ElementFunctions.getParentWithClass(link, 'post-container')
            let url = link.getAttribute('href')
            let id = postContainer.id.split('-')[1]
            let req = new JSONRequestManager(url, { method: 'delete' })
            req.comm()
            .success(data => {
                let row = ElementFunctions.getParentWithClass(postContainer, 'row')
                row.remove()
                document.querySelector(`#js-post-${id}-reply-container`).remove()

                //Get updated page info
                let topicContainer = document.querySelector('.js-topic-container')
                let topicId = topicContainer.id.split("-")[2]
                const url = `/topics/${topicId}/posts`
                let postReq = new JSONRequestManager(url)
                postReq.comm()
                .success(data => {
                    const postArr = data.data
                    const postObjects = postArr.map(postData => new Post({data: postData, included: data.included})).reverse()
                    //delete all posts
                    const objectsToRemove = [...topicContainer.parentElement.children].slice(2)
                    for(let objToRem of objectsToRemove){
                        objToRem.remove()
                    }
                    for(let postObject of postObjects){
                        postObject.displayAtBottom()
                    }
                })
                .error(e => {
                    const flashMessage = new FlashMessage('danger', e)
                    const flashTemplate = HandlebarsTemplates['flash_message'](flashMessage)
                    const contentDiv = document.querySelector('#flash-message')
                    contentDiv.innerHTML = flashTemplate
                })
            })
            .error(er => {
                const flashMessage = new FlashMessage('danger', er)
                const flashTemplate = HandlebarsTemplates['flash_message'](flashMessage)
                const contentDiv = document.querySelector('#flash-message')
                contentDiv.innerHTML = flashTemplate
            })
        }else if(isReportButton(link)){
            e.preventDefault()
            console.log('report')
            let postContainer = ElementFunctions.getParentWithClass(link, 'post-container')
            const url = link.getAttribute('href')
            const req = new JSONRequestManager(url, { method: 'post'})
            req.comm()
            .success(data => {
                const flashMessage = new FlashMessage('success', "Your report has been sent")
                const flashTemplate = HandlebarsTemplates['flash_message'](flashMessage)
                const contentDiv = document.querySelector('#flash-message')
                contentDiv.innerHTML = flashTemplate
            })
            .error(err => {
                const flashMessage = new FlashMessage('danger', 'Failed to send report')
                const flashTemplate = HandlebarsTemplates['flash_message'](flashMessage)
                const contentDiv = document.querySelector('#flash-message')
                contentDiv.innerHTML = flashTemplate
            })
        }
    })
}