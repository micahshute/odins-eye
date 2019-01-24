class Email{

    constructor(email){
        this.email = email
    }

    get isValidEmail(){
        let atToDot = this.email.match(/@[\w]+./)
        let atToEnd = this.email.match(/@[\w]+.[\w]+/)
        if(atToDot && atToEnd){
            return atToDot[0].length >= 3 && (atToEnd[0].length - atToDot[0].length >= 1)
        }
        return false
    }

    get isValid(){
        if(this.isvalidEmail){
            return this.isUnique
        }else{
            return false
        }
    }

    isUnique(){
        let req = new JSONRequestManager(`api/users/check-email`, {method: "post", body: {email: this.email}})
        return req.pfetch()
    }

}