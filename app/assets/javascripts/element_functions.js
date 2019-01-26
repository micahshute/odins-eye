class ElementFunctions{

    static getParentLinkFromClick(e){
        let target = e.target;
        if(target.tagName !== "A" && target.parentElement.tagName === "A"){
            target = target.parentElement;
        }
        return target;
    }   

    static getParentWithClass(el, klass){
        let parentEl = el
        while(!parentEl.classList.contains(klass)){
            parentEl = parentEl.parentElement
            if(parentEl.tagName === 'BODY'){
                return null
            }
        }

        return parentEl
  
    }

    static getParentOfType(el, type){
        let parentEl = el
        while(!(parentEl.tagName === type.toUpperCase())){
            parentEl = parentEl.parentElement
            if(parentEl.tagName === 'BODY'){
                return null
            }
        }
        return parentEl
    }

    static getChildWithClass(el, klass){
        let queue = [el]
        while(queue.length > 0){
            let child = queue.shift()
            if(child.classList && child.classList.contains(klass)) return child
            if(child.children && child.children.length > 0) queue = queue.concat([...child.children])
        }
        return null
    }

    static getChildWithType(el, type){
        let queue = [el]
        while(queue.length > 0){
            let child = queue.shift()
            if(child){
                if(child.tagName === type.toUpperCase()) return child
                if(child.children.length > 0) queue = queue.concat([...child.children])
            }
        }
        return null
    }

    static nodeListToArray(nodeList){
        return [...nodeList]
    }

    static getSiblingWithType(el, type){
        return this.getChildWithType(el.parentElement, type)
    }

    static getSiblingWithClass(el, klass){
        return this.getChildWithClass(el.parentElement, klass)
    }

    static toggleClasses({element, addClass, removeClass} = {}){
        if(element.classList.contains(removeClass)){
            element.classList.remove(removeClass)
        }
        if(!element.classList.contains(addClass)){
            element.classList.add(addClass)
        }
    }

    static addClass({element, klass}){
        if(!element.classList.contains(klass)){
            element.classList.add(klass)
        }
    }   

    static removeClass({element, klass}){
        if(element.classList.contains(klass)){
            element.classList.remove(klass)
        }
    }   

}