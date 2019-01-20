document.addEventListener('DOMContentLoaded', function(){
    addUserActionEventListeners();
});

class FollowUserButton{

    static validateElement(el){
        let klass = 'js-follow-user-button'
        return !!el.classList.contains(klass)
    }

    static newFromId(userId){
        const element = document.querySelector(`#js-follow-user-${userId}`)
        return new FollowUserButton(element)
    }

    constructor(element){
        this.element = element
        this.url = element.getAttribute('href');
        this.userId = this.element.id.split('-')[this.element.id.split('-').length - 1]
        this.imgEl = this.element.children[0]
        this.baseColor = 'bg-offwhite'
        this.selectedColor = 'bg-aqua'
        this.selected = this.element.classList.contains(this.selectedColor)
    }

    follow(){
        if(!this.selected){
            this.element.classList.remove(this.baseColor)
            this.element.classList.add(this.selectedColor)
        }
    }

    unFollow(){
        if(this.selected){
            this.element.classList.remove(this.selectedColor)
            this.element.classList.add(this.baseColor)
        }

    }

    updateUI(data){
        if(data.following){
            this.follow()
        }else{
            this.unFollow()
        }
    }

    async toggle(){
        if(this.selected){
            this.unFollow()
        }else{
            this.follow()
        }
        const req = new JSONRequestManager(this.url, { method: "POST"})
        const data = await req.afetch();
        this.updateUI(data.data)
    }

}



function addUserActionEventListeners(){
    document.addEventListener('click', function(e){
        let link = ElementFunctions.getParentLinkFromClick(e)
        if(FollowUserButton.validateElement(link)){
            e.preventDefault()
            const btn = new FollowUserButton(link)
            btn.toggle()
        }
    })
}