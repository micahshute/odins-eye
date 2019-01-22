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
            if(child.classList.contains(klass)) return child
            queue = queue.concat([...child.children])
        }
        return null
    }

    static getChildWithType(el, type){
        let queue = [el]
        while(queue.length > 0){
            let child = queue.shift()
            if(child.tagName === type.toUpperCase()) return child
            queue = queue.concat([...child.children])
        }
        return null
    }

    static nodeListToArray(nodeList){
        return [...nodeList]
    }

}