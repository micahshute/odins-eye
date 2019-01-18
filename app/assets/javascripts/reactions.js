document.addEventListener('DOMContentLoaded', function(){
    attachResponseEventListeners();
})



function PostReactions(postId){
    const reactionTypes = {
        "1": "like",
        "2": "dislike",
        "3": "genius"
    }
    this.postId = postId;
    this.reactionElements = document.querySelector(`#post-reactions-${this.postId}`).children;
    this.like = function(){ 
        if(this.reactionElements[1].childNodes[0].classList.contains('color-charcoal')){
            this.reactionElements[1].childNodes[0].classList.remove('color-charcoal');
            this.reactionElements[1].childNodes[0].classList.add('color-aqua')
        }
    }
    this.removeLike = function(){
        if(this.reactionElements[1].childNodes[0].classList.contains('color-aqua')){
            this.reactionElements[1].childNodes[0].classList.remove('color-aqua');
            this.reactionElements[1].childNodes[0].classList.add('color-charcoal');
        }
    }

    this.dislike = function(){
        if(this.reactionElements[2].childNodes[0].classList.contains('color-charcoal')){
            this.reactionElements[2].childNodes[0].classList.remove('color-charcoal');
            this.reactionElements[2].childNodes[0].classList.add('color-aqua');
        }
    }

    this.removeDislike = function(){
        if(this.reactionElements[2].childNodes[0].classList.contains('color-aqua')){
            this.reactionElements[2].childNodes[0].classList.remove('color-aqua');
            this.reactionElements[2].childNodes[0].classList.add('color-charcoal');
        }
    }

    this.genius = function(){
        if(this.reactionElements[0].childNodes[0].classList.contains('color-charcoal')){
            this.reactionElements[0].childNodes[0].classList.remove('color-charcoal');
            this.reactionElements[0].childNodes[0].classList.add('color-aqua');
        }
    }

    this.removeGenius = function(){
        if(this.reactionElements[0].childNodes[0].classList.contains('color-aqua')){
            this.reactionElements[0].childNodes[0].classList.remove('color-aqua');
            this.reactionElements[0].childNodes[0].classList.add('color-charcoal');
        }
    }

    this.doesLike = function(bool){ bool ? this.like() : this.removeLike() }

    this.doesDislike = function(bool){ bool ? this.dislike() : this.removeDislike() }

    this.doesGenius = function(bool){ bool ? this.genius() : this.removeGenius() }

    this.updateLikeCount = (count) => {
        this.reactionElements[1].childNodes[1].textContent = "  " + count;
    }

    this.updateDislikeCount = function(count){
        this.reactionElements[2].childNodes[1].textContent = "  " + count;
    }

    this.updateGeniusCount = function(count){
        this.reactionElements[0].childNodes[1].textContent = "  " + count;
    }

    this.update = function(dataset){
        for(data of dataset){
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
}

function TopicReaction(topicId){

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
                    let reactions = new PostReactions(data.reactableId)
                    reactions.update(data.data)
                }else if(data.reactableType === "Topic"){

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