class Functions{

    static pluralize(num, word){
        if(num == 1){
            return `${num} ${word}`
        }
        const lastLetter = word.slice(-1)
        switch(lastLetter){
            case "y":
                return `${num} ${word.slice(0,-1)}ies`
            case "s":
                if(word.slice(-2) === "us"){
                    return `${num} ${word.slice(0,-2)}i`
                }else{
                    return `${num} ${word}`
                }
                break;
            case "f":
                if(word.slice(-2) === "lf"){
                    return `${num} ${word.slice(0,-1)}ves`
                }
            default:
                return `${num} ${word}s`
        }   
    }
}