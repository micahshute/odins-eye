class URLParamsManager{
    constructor(obj){
        this.params = obj
    }

    add(hash){
        this.params = {...obj, hash}
    }

    remove(key){
        return delete this.params[key]
    }

    get urlParams(){
        let paramString = "?"
        for(let key in this.params){
            paramString += `${key.toLowerCase()}=${this.params[key].toString().toLowerCase()}&`
        }
        return paramString.slice(0,-1)
    }

    getUrl(baseUrl){
        return encodeURI(baseUrl + this.urlParams)
    }
}