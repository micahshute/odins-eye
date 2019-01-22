document.addEventListener('DOMContentLoaded', function(){
    attachResponseEventListeners();
})


class Reactions{

    static isReactionLink(el){
        return ((el.tagName === "A") && el.classList.contains("reaction"))
    }

    constructor(reactableId, reactableType){
        this.reactableId = reactableId;
        this.reactableType = reactableType;
    }

    get likes(){
        return parseInt(this.reactionElements[1].children[1].textContent)
    }

    get dislikes(){
        return parseInt(this.reactionElements[2].children[1].textContent)
    }

    get geniuses(){
        return parseInt(this.reactionElements[0].children[1].textContent)
    }

    update(dataset){
        for(let data of dataset){
            switch(data.reactionType){
                case "like":
                    this.doesLike(data.userRespond)
                    this.updateLikeCount(data.reactionCount)
                    break;
    
                case "dislike":
                    this.doesDislike(data.userRespond)
                    this.updateDislikeCount(data.reactionCount)
                    break;
    
                case "genius":
                    this.doesGenius(data.userRespond)
                    this.updateGeniusCount(data.reactionCount)
                    break;
                
                default:
                    console.log("ERROR IN REACTIONTYPE");
            }
    
        }
    }

    doesLike (bool) { 
        bool ? this.like() : this.removeLike() 
    }

    doesDislike (bool) { 
        bool ? this.dislike() : this.removeDislike() 
    }

    doesGenius (bool) { 
        bool ? this.genius() : this.removeGenius() 
    }

    updateLikeCount (count) {
        this.reactionElements[1].childNodes[1].textContent = "  " + count;
    }

    updateDislikeCount (count){
        this.reactionElements[2].childNodes[1].textContent = "  " + count;
    }

    updateGeniusCount (count){
        this.reactionElements[0].childNodes[1].textContent = "  " + count;
    }

    toggleUI(target){
        if(target === this.reactionElements[0]){
            if(this.geniused){
                this.removeGenius()
                this.updateGeniusCount(this.geniuses - 1)
            }else{
                this.genius()
                this.updateGeniusCount(this.geniuses + 1)
                if(this.disliked){
                    this.updateDislikeCount(this.dislikes - 1)
                }
                this.removeDislike()
                
            }
        }else if(target === this.reactionElements[1]){
            if(this.liked){
                this.removeLike()
                this.updateLikeCount(this.likes - 1)
            }else{
                this.like()
                this.updateLikeCount(this.likes + 1)
                if(this.disliked){
                    this.updateDislikeCount(this.dislikes - 1)
                }
                this.removeDislike()
                
            }
        }else if(target === this.reactionElements[2]){
            if(this.disliked){
                this.removeDislike()
                this.updateDislikeCount(this.dislikes - 1)
            }else{
                this.dislike()
                this.updateDislikeCount(this.dislikes + 1)
                if(this.liked){
                    this.updateLikeCount(this.likes - 1)
                }
                if(this.geniused){
                    this.updateGeniusCount(this.geniuses - 1)
                }
                this.removeLike()
                this.removeGenius()
                
            }
        }
    }
}

class PostReactions extends Reactions{

    constructor(postId){
        super(postId, "Post");
        this.postId = this.reactableId;
        this.reactionElements = document.querySelector(`#post-reactions-${this.postId}`).children;
    }

    get liked(){
        return this.reactionElements[1].childNodes[0].classList.contains('color-aqua')
    }

    get disliked(){
        return this.reactionElements[2].childNodes[0].classList.contains('color-aqua')
    }

    get geniused(){
        return this.reactionElements[0].childNodes[0].classList.contains('color-aqua')
    }

    like(){ 
        if(this.reactionElements[1].childNodes[0].classList.contains('color-charcoal')){
            this.reactionElements[1].childNodes[0].classList.remove('color-charcoal');
            this.reactionElements[1].childNodes[0].classList.add('color-aqua')
        }
    }
    removeLike(){
        if(this.reactionElements[1].childNodes[0].classList.contains('color-aqua')){
            this.reactionElements[1].childNodes[0].classList.remove('color-aqua');
            this.reactionElements[1].childNodes[0].classList.add('color-charcoal');
        }
    }

    dislike(){
        if(this.reactionElements[2].childNodes[0].classList.contains('color-charcoal')){
            this.reactionElements[2].childNodes[0].classList.remove('color-charcoal');
            this.reactionElements[2].childNodes[0].classList.add('color-aqua');
        }
    }

    removeDislike(){
        if(this.reactionElements[2].childNodes[0].classList.contains('color-aqua')){
            this.reactionElements[2].childNodes[0].classList.remove('color-aqua');
            this.reactionElements[2].childNodes[0].classList.add('color-charcoal');
        }
    }

    genius(){
        if(this.reactionElements[0].childNodes[0].classList.contains('color-charcoal')){
            this.reactionElements[0].childNodes[0].classList.remove('color-charcoal');
            this.reactionElements[0].childNodes[0].classList.add('color-aqua');
        }
    }

    removeGenius(){
        if(this.reactionElements[0].childNodes[0].classList.contains('color-aqua')){
            this.reactionElements[0].childNodes[0].classList.remove('color-aqua');
            this.reactionElements[0].childNodes[0].classList.add('color-charcoal');
        }
    }

}

class TopicReactions extends Reactions{

    constructor(topicId){
        super(topicId, "Topic")
        this.topicId = topicId
        this.reactionElements = document.querySelector(`#topic-reactions-${this.topicId}`).children;
    }

    get liked(){
        return this.reactionElements[1].classList.contains('topic-option-selected')
    }

    get disliked(){
        return this.reactionElements[2].classList.contains('topic-option-selected')
    }

    get geniused(){
        return this.reactionElements[0].classList.contains('topic-option-selected')
    }

    like(){ 
        if(!this.reactionElements[1].classList.contains('topic-option-selected')){
            this.reactionElements[1].classList.add('topic-option-selected')
        }
    }

    removeLike(){
        if(this.reactionElements[1].classList.contains('topic-option-selected')){
            this.reactionElements[1].classList.remove('topic-option-selected');
        }
    }

    dislike(){
        if(!this.reactionElements[2].classList.contains('topic-option-selected')){
            this.reactionElements[2].classList.add('topic-option-selected');
        }
    }

    removeDislike(){
        if(this.reactionElements[2].classList.contains('topic-option-selected')){
            this.reactionElements[2].classList.remove('topic-option-selected');
        }
    }

    genius(){
        if(!this.reactionElements[0].classList.contains('topic-option-selected')){
            this.reactionElements[0].classList.add('topic-option-selected');
        }
    }

    removeGenius(){
        if(this.reactionElements[0].classList.contains('topic-option-selected')){
            this.reactionElements[0].classList.remove('topic-option-selected');
        }
    }

}

class SaveButton{

    static newFromElement(element){
        const idString = element.id
        const idComponents = idString.split('-')
        const id = idComponents[idComponents.length - 1]
        const btn = new SaveButton(id)
        btn.element = element
        btn.imageEl = btn.element.children[0]
        btn.inSummary = btn.element.parentElement.classList.contains('js-summary-reaction-parent')
        btn.inSpotlight = btn.element.parentElement.classList.contains('spotlight-container');
        btn.inFeaturedTopics = btn.element.parentElement.classList.contains('js-tag-spotlight');
        if(btn.inSummary || btn.inFeaturedTopics){
            btn.selectedColor = 'color-aqua'
            btn.imgColor = 'color-charcoal'
        }else if (btn.inSpotlight){
            btn.selectedColor = 'color-sunshine'
            btn.imgColor = 'color-charcoal'
        }else{
            btn.imgColor = 'color-offwhite'
            btn.selectedColor = 'color-offwhite'
        }
        return btn;
    }

    static isSaveButton(el){
        return (el.tagName === "A") && el.classList.contains('save-button')
    }

    constructor(topicId){
        this.topicId = topicId;
        this.element = document.querySelector(`#save-topic-${topicId}`);
        this.url = this.element.getAttribute('href')
        this.imageEl = this.element.children[0]
        this.inSummary = this.element.parentElement.classList.contains('js-summary-reaction-parent')
        this.inSpotlight = this.element.parentElement.classList.contains('spotlight-container');
        this.inFeaturedTopics = this.element.parentElement.classList.contains('js-tag-spotlight');
        this.inReadingList = !!document.querySelector('h1#js-reading-list')
        if(this.inSummary || this.inFeaturedTopics){
            this.selectedColor = 'color-aqua'
            this.imgColor = 'color-charcoal'
        }else if (this.inSpotlight){
            this.selectedColor = 'color-sunshine'
            this.imgColor = 'color-charcoal'
        }else{
            this.imgColor = 'color-offwhite'
            this.selectedColor = 'color-offwhite'
        }
    }

    get selected(){
        if(this.inSummary || this.inSpotlight || this.inFeaturedTopics){
            if(this.imageEl.classList.contains(this.imgColor)){
                return false
            }else{
                return true
            }
        }else{
            if(this.element.classList.contains('topic-option-selected')){
                return true
            }else{
                return false
            }
        }
    }

    readingListRow(){
        let parentEl = this.element
        while(!parentEl.classList.contains('js-reading-item')){
            parentEl = parentEl.parentElement
        }
        return parentEl
    }

    saved(){
        if(this.inSummary || this.inSpotlight || this.inFeaturedTopics){
            if(this.imageEl.classList.contains(this.imgColor)){
                this.imageEl.classList.remove(this.imgColor)
                this.imageEl.classList.add(this.selectedColor)
            }
        }else{
            if(!this.element.classList.contains('topic-option-selected')){
                this.element.classList.add('topic-option-selected')
            }
        }
    }

    notSaved(){
        if(this.inReadingList){
            this.readingListRow().remove()
            return
        }
        if(this.inSummary || this.inSpotlight || this.inFeaturedTopics){
            if(this.imageEl.classList.contains(this.selectedColor)){
                this.imageEl.classList.remove(this.selectedColor)
                this.imageEl.classList.add(this.imgColor)
            }
        }else{
            if(this.element.classList.contains('topic-option-selected')){
                this.element.classList.remove('topic-option-selected')
            }
        }
    }

    updateUI(data){
        if(data.data.saved){
            this.saved()
        }else{
            this.notSaved()
        }
    }

    toggleUI(){
        if(this.selected){
            this.notSaved()
        }else{
            this.saved()
        }
    }

    async update(){
        this.toggleUI();
        const req = new JSONRequestManager(this.url, { method: "POST" })
         try{
            const data = await req.afetch()
            if(data.data.saved){
                this.saved()
            }else{
                this.notSaved()
            }
            return data;
         }catch(err){
             console.log(err)
         }
    }

    async updateAll(){
        const duplicateElements = [].slice.call(document.querySelectorAll(`#save-topic-${this.topicId}`));
        const dupObjects = duplicateElements.map((el) => SaveButton.newFromElement(el));
        if(dupObjects.length === 1){
            dupObjects[0].toggleUI()
            dupObjects[0].update()
        }else{
            dupObjects[0].toggleUI()
            let data = await dupObjects[0].update()
            let btns = dupObjects.slice(1)
            for(let btn of btns){
                btn.updateUI(data)
            }
        }
    }

}



const attachResponseEventListeners = () => {
    document.addEventListener('click', function(e){
        const target = ElementFunctions.getParentLinkFromClick(e)
        if(Reactions.isReactionLink(target)){
            e.preventDefault();
            const encasingDiv = ElementFunctions.getParentOfType(target, "div");
            const reactableType = encasingDiv.id.split('-')[0]
            const reactableId = encasingDiv.id.split('-')[2]
            if(reactableType === "post"){
                let reactions = new PostReactions(reactableId)
                reactions.toggleUI(target)
            }else if(reactableType === "topic"){
                let reactions = new TopicReactions(reactableId)
                reactions.toggleUI(target)
            }
            const url = target.getAttribute("href");
            const jsonReq = new JSONRequestManager(url, { method: "POST"});
            jsonReq.comm()
            .success(function(data){
                if(data.reactableType === "Post"){
                    let reactions = new PostReactions(data.reactableId)
                    reactions.update(data.data)
                }else if(data.reactableType === "Topic"){
                    let reactions = new TopicReactions(data.reactableId)
                    reactions.update(data.data)
                }else{
                    console.log("REACTABLE TYPE ERROR")
                }
            })
            .error(function(error){
                console.log(error)
            })
        }else if(SaveButton.isSaveButton(target)){
            e.preventDefault();
            const btn = SaveButton.newFromElement(target);
            btn.updateAll();
        }
    });

    
}