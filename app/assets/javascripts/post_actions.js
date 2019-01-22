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
            let postContainer = ElementFunctions.getParentWithClass(link, 'post-container')
            console.log(postContainer)
            let id = postContainer.id.split('-')[1]
            
        }else if(isDeleteButton(link)){
            e.preventDefault()
            console.log(`delete`)
            let postContainer = ElementFunctions.getParentWithClass(link, 'post-container')
            console.log(postContainer)
        }else if(isReportButton(link)){
            e.preventDefault()
            console.log('report')
            let postContainer = ElementFunctions.getParentWithClass(link, 'post-container')
            console.log(postContainer)
        }
    })
}