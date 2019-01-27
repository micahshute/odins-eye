class CurrentUser{

    static async create(){
        try{
            const data = await this.data()
            return new User(data.attributes.id, data.attributes.name)
        }catch(e){
            const flash = new FlashMessage('danger', e)
            flash.render()
            return null
        }
    }

    static async id(){
        try{
            const data = await this.data()
            return data.data.attributes.id
        }catch(e){
            const flash = new FlashMessage('danger', e)
            flash.render()
            return null
        }
    }

    static async name(){
        try{
            const data = await this.data()
            return data.data.attributes.name
        }catch(e){
            const flash = new FlashMessage('danger', e)
            flash.render()
            return null
        }
    }

    static async email(){
        try{
            const data = await this.data()
            return data.data.attributes.email
        }catch(e){
            const flash = new FlashMessage('danger', e)
            flash.render()
            return null
        }
    }
    

    static get sLoggedIn(){
        const req = new JSONRequestManager('/api/users/logged-in')
        return req.comm()
    }

    static async loggedIn(){
        const req = new JSONRequestManager('/api/users/logged-in')
        return req.afetch()
    }

    static get sData(){
        const req = new JSONRequestManager('/api/users/current-user')
        return req.comm()
    }

    static async data(){
        const req = new JSONRequestManager('/api/users/current-user')
        return await req.afetch()
    }

    static async reactionsForPost(postId){
        const req = new JSONRequestManager(`/api/reactions/users/current-user/posts/${postId}`)
        return await req.afetch()
    }

    static async reactionsForTopic(topicId){
        const req = new JSONRequestManager(`/api/reactions/users/current-user/topics/${topicId}`)
        return await req.afetch()
    }

    static async likesTopic(topicId){
        return await reactedToReactable({reaction: 'like', reactableId: topicId, reactableType: 'topic'})
    }

    static async dislikesTopic(topicId){
        return await reactedToReactable({reaction: 'dislike', reactableId: topicId, reactableType: 'topic'})
    }

    static async geniusesTopic(topicId){
        return await reactedToReactable({reaction: 'genius', reactableId: topicId, reactableType: 'topic'})
    }

    static async likesPost(postId){
        return await reactedToReactable({reaction: 'like', reactableId: postId, reactableType: 'post'})
    }

    static async dislikesPost(postId){
        return await reactedToReactable({reaction: 'dislike', reactableId: postId, reactableType: 'post'})
    }

    static async geniusesPost(postId){
        return await reactedToReactable({reaction: 'genius', reactableId: postId, reactableType: 'post'})
    }

    static async reactedToReactable({reaction, reactableId, reactableType}){
        try{
            const req = new JSONRequestManager(`api/users/current-user/${reactableType}s/${reactableId}/${reaction}`)
            const data = await req.afetch()
            return data.data
        }catch(e){
            const flash = new FlashMessage('danger', e)
            flash.render()
            return null
        }
    }

    static async reactions(){
        try{
            const req = new JSONRequestManager('api/users/current-user/reactions')
            return await req.afetch()
        }catch(e){
            const flash = new FlashMessage('danger', e)
            flash.render()
            return null
        }
    }
}