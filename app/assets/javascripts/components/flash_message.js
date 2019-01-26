class FlashMessage{

    constructor(type, content){
        this.type = type
        this.content = content
    }

    get html(){
        return HandlebarsTemplates['flash_message'](this)
    }

    render(){
        const contentDiv = document.querySelector('#flash-message')
        contentDiv.innerHTML = this.html
    }
    
}