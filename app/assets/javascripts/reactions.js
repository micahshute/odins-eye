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

const attachResponseEventListeners = () => {
    const reactionLinks = document.querySelectorAll('a.reaction');
        document.addEventListener('click', function(e){
        const target = getParentLink(e)
        if(isReactionLink(target)){
            e.preventDefault();
            const url = target.getAttribute("href");
            const jsonReq = new JSONRequestManager(url, { method: "POST"});
            jsonReq.comm()
            .success(function(data){
                if(data.reactableType === "Post"){
                    console.log(data.data)
                    let reactions = new PostReactions(data.reactableId)
                    console.log(reactions)
                    reactions.update(data.data)
                }else if(data.reactableType === "Topic"){
                    console.log(data)
                    let reactions = new TopicReactions(data.reactableId)
                    reactions.update(data.data)
                }else{
                    console.log("REACTABLE TYPE ERROR")
                }
            })
            .error(function(error){
                console.log(error)
            })
        }
    })
}