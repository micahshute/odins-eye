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
    document.addEventListener('click', async function(e){
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
            try{
                let data = await req.afetch()
                let row = ElementFunctions.getParentWithClass(postContainer, 'row')
                row.remove()
                document.querySelector(`#js-post-${id}-reply-container`).remove()

                //Get updated page info
                let topicContainer = document.querySelector('.js-topic-container')
                let topicId = topicContainer.id.split("-")[2]
                const url = `/topics/${topicId}/posts`
                const pm = new PaginationManager({baseUrl: url})
                data = await pm.relaod()
                const postArr = data.data
                const postObjects = postArr.map(postData => new Post({data: postData, included: data.included}))
                //delete all posts
                
                let html = ''
                for(let postObject of postObjects){
                    await postObject.fetchUserData()
                    html += postObject.fullHtml
                }
                pm.dataContainer.innerHTML = html

            }catch(e){
                const flash = new FlashMessage('danger', e)
                flash.render()
            }
        }else if(isReportButton(link)){
            e.preventDefault()
            const url = link.getAttribute('href')
            const req = new JSONRequestManager(url, { method: 'post'})
            try{

                let data = await req.afetch()
                const flashMessage = new FlashMessage('success', "Your report has been sent")
                flashMessage.render()

            }catch(e){
                const flash = new FlashMessage('danger', e)
                flash.render()
            }

        }
    })
}


async function viewPostReplies(self){
    const id = self.id.split('-')[0]
    self.className = ""
    self.innerHTML = "<div class='loader center'></div>"
    self.setAttribute('onclick', '')
    const req = new JSONRequestManager(`/api/posts/${id}/replies`)
    try{
        const data = await req.afetch()
        const postArr = data.data
        const postObjects = postArr.map(postData => new Post({data: postData, included: data.included})).reverse()
        const replyContainer = document.querySelector(`#js-post-${id}-reply-container`)
        replyContainer.innerHTML = ''
        let nextSibling = replyContainer.nextSibling 
        while(nextSibling !== self){
            const removeEl = nextSibling
            nextSibling = nextSibling.nextSibling
            removeEl.remove() 
        }
        let htmlToRender = ''
        for(let post of postObjects){
            await post.fetchUserData()
            htmlToRender += post.fullHtml
        }
        self.innerHTML = htmlToRender
    }catch(e){
        const flash = new FlashMessage('danger', e)
        flash.render()
    }
}


async function postPaginate(btn){
    const topicId = getTopicIdFromPage()
    const baseUrl = `/topics/${topicId}/posts`
    try{
        const pm = new PaginationManager({baseUrl: baseUrl})
        const json = await pm.click(btn)
        const data = json
        await renderPosts(data, pm.dataContainer)

    }catch(e){
        const flashMessage = new FlashMessage('danger', e)
        flashMessage.render()
    }
}

function getTopicIdFromPage(){
    const topicContainer = document.querySelector('.js-topic-container')
    return topicContainer.id.split('-')[2]
}

async function renderPosts(data, container){
    const postDataArr = data.data
    const postObjects = postDataArr.map(postData => new Post({data: postData, included: data.included}))
    let content = ""
    for(let post of postObjects){
        await post.fetchUserData()
        content += post.fullHtml
    }
    container.innerHTML = content
}