document.addEventListener('DOMContentLoaded', async function(){
    let url
    const topicPage = document.querySelector('.js-topic-container')
    const rootPage = document.querySelector('.spotlight-container')
    if(topicPage){
        const id  = topicPage.id.split('-')[2]
        url = `/topics/${id}/posts`
    }else if(rootPage){
        url = `/api/topics/recent`
    }
    const pm = new PaginationManager()
    const req = new JSONRequestManager(url)
    const data = await req.afetch()
    pm.totalItems = data.data.length > 0 ? data.data[0].meta.count : 0
    pm.initialize()
})