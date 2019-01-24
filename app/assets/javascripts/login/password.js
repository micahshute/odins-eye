class Password{

    constructor(password = ""){
        this._password = password
        this._confirmPassword = ""
    }

    get isValid(){
        return this.passwordsMatch && this.isAppropriateLength && this.containsRequiredCharacters
    }

    get password(){
        return this._password
    }

    get confirmPassword(){
        return this._confirmPassword
    }

    get minimumCharacters(){
        return 8
    }

    get maximumCharacters(){
        return 20
    }

    get requiredSymbols(){
        return '!@#$'
    }

    get isTooShort(){
        return this.password.length < this.minimumCharacters
    }

    get isTooLong(){
        return this.password.length > this.maximumCharacters
    }

    get isAppropriateLength(){
        return !this.isTooShort && !this.isTooLong
    }

    get hasLowerCaseSymbol(){
        return !!this.password.match(/[a-z]/)
    }

    get hasUpperCaseSymbol(){
        return !!this.password.match(/[A-Z]/)
    }

    get hasRequiredSymbols(){
        return !!this.password.match(new RegExp(`[$${this.requiredSymbols}]`))
    }

    get hasNumber(){
        return !!this.password.match(/[0-9]/)
    }


    get containsRequiredCharacters(){
        return this.hasLowerCaseSymbol && this.hasUpperCaseSymbol && this.hasRequiredSymbols && this.hasNumber
    }

    errors(errorFields = ['passwordConfirmationError', 'lengthError', 'symbolError']){
        if(this.isValid){
            return ""
        }else{
            return errorFields.map(f => this[f]).filter(e => e != null).join(" ; ")
        }
    }

    get passwordConfirmationError(){
        if(!this.passwordsMatch){
            return "Passwords do not match"
        }else{
            return null
        }
    }

    get passwordFieldErrors(){
        return this.errors(['lengthError', 'symbolError'])
    }

    get confirmPasswordFieldErrors(){
        return this.errors(['passwordConfirmationError'])
    }

    get lengthError(){
        if(!this.isAppropriateLength){
            return "Password must be between 8 and 20 characters"
        }
    }

    get symbolError(){
        if(!this.containsRequiredCharacters){
            return "Password must contain at least one lower case and one upper case character, one number, and one of the following symbols: !@#$"
        }
    }

    get passwordsMatch(){
        return this.password === this.confirmPassword
    }

    set password(newPassword){
        this._password = newPassword
    }

    set confirmPassword(newPassword){
        this._confirmPassword = newPassword
    }


}