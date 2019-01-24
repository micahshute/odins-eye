class User{

    constructor(id, name){
        this.id = id;
        this.name = name;
    }

    get path(){
        return `/users/${this.id}`
    }
}