class Topic{

    constructor(data){
        let attr = data.attributes
        this.id = attr.id
        this.title = attr.title
        this.errors = attr.errors
        this.createdAt = attr.created_display
        this.updatedAt = attr.edited_display
        this.content = attr.content
        this.likes = attr.likes
        this.dislikes = attr.dislikes
        this.geniuses = attr.geniuses
        this.author = new User(attr.author_id, attr.author)
        this.views = attr.views
        this.unselectedColor = attr.unselectedColor
        this.selectedColor = attr.selectedColor
        this.tags = data.meta.tags
        this.owned = false
        this.sizeClass = attr.reactionIconSizeClass
    }

    get strippedContent(){
        return this.content.replace(/<[^>]+>/g, "")
    }

    get summaryContent(){
        return this.strippedContent.slice(0,75)
    }

    get summaryHtml(){
        return HandlebarsTemplates['topics/topic_summary'](this)
    }

    get summaryCard(){
        return HandlebarsTemplates['topics/topic_summary_card'](this)
    }

    async fetchUserData(){
        try{
            const currentUserData = await CurrentUser.data()
            this.loggedIn = !!currentUserData.data
            if(this.loggedIn){
                this.owned = parseInt(currentUserData.data.id) === parseInt(this.author.id)
                const data = await CurrentUser.reactionsForTopic(this.id)
                this.liked = data.data.like
                this.disliked = data.data.dislike
                this.geniused = data.data.genius
                this.saved = data.data.save
            }
        }catch{
            const flash = new FlashMessage("danger", e)
            flash.render()
        }
    }


}