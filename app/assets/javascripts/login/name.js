class Name{

    constructor(name = ""){
        this._name = name
    }

    get isValid(){
        return !this.name.match(/[^ A-Za-z'-]/) && this.name.length > 0
    }

    get name(){
        return this._name
    }

    set name(newName){
        this._name = newName
    }
}