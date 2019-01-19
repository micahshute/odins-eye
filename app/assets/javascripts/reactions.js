document.addEventListener('DOMContentLoaded', function(){
    attachResponseEventListeners();
})


class Reactions{

    constructor(reactableId, reactableType){
        this.reactableId = reactableId;
        this.reactableType = reactableType;
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

}

class PostReactions extends Reactions{

    constructor(postId){
        super(postId, "Post");
        this.postId = this.reactableId;
        this.reactionElements = document.querySelector(`#post-reactions-${this.postId}`).children;
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
        const idString = element.id;
        const idComponents = idString.split('-');
        const id = idComponents[idComponents.length - 1]
        return new SaveButton(id)
    }

    constructor(topicId){
        this.topicId = topicId;
        this.element = document.querySelector(`#save-topic-${topicId}`);
        this.url = this.element.getAttribute('href');
        this.imageEl = this.element.children[0]
        this.inSummary = this.element.parentElement.classList.contains('js-summary-reaction-parent')
        this.inSpotlight = this.element.parentElement.classList.contains('spotlight-container');
        this.inFeaturedTopics = this.element.parentElement.classList.contains('js-tag-spotlight');
        if(this.inSummary || this.inFeaturedTopics){
            this.selectedColor = 'color-aqua';
            this.imgColor = 'color-charcoal';
        }else if (this.inSpotlight){
            this.selectedColor = 'color-sunshine'
            this.imgColor = 'color-charcoal';
        }else{
            this.imgColor = 'color-offwhite';
            this.selectedColor = 'color-offwhite'
        }
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

    async update(){
        const req = new JSONRequestManager(this.url, { method: "POST" })
         try{
            console.log(this)
            const res = await req.afetch()
            const data = await res.json()
            if(data.data.saved){
                this.saved()
            }else{
                this.notSaved()
            }
         }catch(err){
             console.log(err)
         }
    }

}


function getParentLink(e){
    let target = e.target;
    if(target.tagName !== "A" && target.parentElement.tagName === "A"){
        target = target.parentElement;
    }
    return target;
}

function isReactionLink(el){
    return ((el.tagName === "A") && el.classList.contains("reaction"))
}

function isSaveButton(el){
    return (el.tagName === "A") && el.classList.contains('save-button')
}



const attachResponseEventListeners = () => {
    document.addEventListener('click', function(e){
        const target = getParentLink(e)
        if(isReactionLink(target)){
            e.preventDefault();
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
        }else if(isSaveButton(target)){
            e.preventDefault();
            const btn = SaveButton.newFromElement(target);
            btn.update();
        }
    });

    
}