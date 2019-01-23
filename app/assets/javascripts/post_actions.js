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
    return (el.tagName === "A" && el.textContent == "Edit")
}


function addPostActionEventListeners(){
    document.addEventListener('click', function(e){
        const link = ElementFunctions.getParentLinkFromClick(e)
        if(isEditButton(link)){
            e.preventDefault()
            console.log(link)
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
                    console.log(data)
                    const postObjects = postArr.map(postData => new Post({data: postData, included: data.included})).reverse()
                    //delete all posts
                    const objectsToRemove = [...topicContainer.parentElement.children].slice(2)
                    console.log(objectsToRemove)
                    for(let objToRem of objectsToRemove){
                        objToRem.remove()
                    }
                    for(let postObject of postObjects){
                        postObject.displayAtBottom()
                    }
                })
                .error(e => {
                    console.log(e)
                })
            })
            .error(er => console.log(er))
        }else if(isReportButton(link)){
            e.preventDefault()
            console.log('report')
            let postContainer = ElementFunctions.getParentWithClass(link, 'post-container')
            console.log(postContainer)
        }
    })
}