
async function rootPagePaginate(btn){
    const baseUrl = '/api/topics/recent'
    try{
        const pm = new PaginationManager({baseUrl: baseUrl})
        const json = await pm.click(btn)
        const userData = await CurrentUser.data()
        
        const loggedIn = userData.data !== null
        const data = {
            ...json,
            templateData: {
                loggedIn: loggedIn,
                selectedColor: 'aqua',
                unselectedColor: 'dusty-rose',
                reactionIconSizeClass: ''
            }
        }
        renderTopics(data, pm.dataContainer)

    }catch(e){
        const flashMessage = new FlashMessage('danger', e)
        flashMessage.render()
    }
}

async function renderTopics(data, container){
    container.innerHTML = ''
    const templateData = data.templateData
    for(let topicData of data.data){
        topicData.attributes = {...topicData.attributes, ...templateData}
        const topicSummary = new Topic(topicData)
        await topicSummary.fetchUserData()
        let html = topicSummary.summaryHtml
        container.innerHTML += html
        container.innerHTML += "<hr>"
    }
}
