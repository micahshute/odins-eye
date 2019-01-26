document.addEventListener('turbolinks:load', function(){
    let form = document.querySelector('.js-signup')
    if(!!form){
        let nameInput = document.querySelector('form.js-signup .js-name-container input')
        let emailInput = document.querySelector('form.js-signup .js-email-container input')
        let passwordInput = document.querySelector('form.js-signup .js-password-container input')
        let confirmPasswordInput = document.querySelector('form.js-signup .js-password-confirmation-container input')
        let name = new Name()
        let email = new Email()
        let password = new Password()
        nameInput.addEventListener('input', function(e){
            let value = nameInput.value
            name.name = value
            let jsErrors = ElementFunctions.getSiblingWithClass(nameInput,'js-errors')
            if(name.isValid){ 
                jsErrors.innerHTML = ""
                ElementFunctions.toggleClasses({element: nameInput, addClass: 'is-valid', removeClass: 'is-invalid'})
            }else{
                ElementFunctions.toggleClasses({element: nameInput, addClass: 'is-invalid', removeClass: 'is-valid'})
                jsErrors.innerHTML = `<p class="error-text small-text">Name must have at least one character, and cannot have numbers or symbols</p>`
            }
        })

        emailInput.addEventListener('blur', function(e){
            let value = emailInput.value
            email.email = value
            let jsErrors = ElementFunctions.getSiblingWithClass(emailInput, 'js-errors')
            email.isUnique()
            .then(res => res.json() )
            .then(data => {
                let uniqueError = document.querySelector('#js-unique-email-error')
                if(uniqueError) uniqueError.remove()
                if(!data.data){
                    if(email.isValidEmail) jsErrors.innerHTML = ""
                    if(email.isValidEmail) ElementFunctions.toggleClasses({element: emailInput, addClass: 'is-valid', removeClass: 'is-invalid'})
                }else{
                    ElementFunctions.toggleClasses({element: emailInput, addClass: 'is-invalid', removeClass: 'is-valid'})
                    jsErrors.innerHTML += `<p id="js-unique-email-error" class="error-text small-text">This email already has an account</p>`
                }
            })
            .catch(e => console.log(e))
            if(email.isValidEmail){
                jsErrors.innerHTML = ""
            }else{
                jsErrors.innerHTML = ""
                ElementFunctions.toggleClasses({element: emailInput, addClass: 'is-invalid', removeClass: 'is-valid'})
                jsErrors.innerHTML = `<p id="js-email-format-valid" class="error-text small-text">Not a proper email address</p>`
            }

        })


        passwordInput.addEventListener('input', function(e){
            let value = passwordInput.value
            password.password = value
            let jsErrors = ElementFunctions.getSiblingWithClass(passwordInput, 'js-errors')
            let errors = password.passwordFieldErrors
            if(password.passwordFieldErrors === ""){
                ElementFunctions.toggleClasses({element: passwordInput, addClass: 'is-valid', removeClass: 'is-invalid'})
                jsErrors.innerHTML = errors
            }else{
                ElementFunctions.toggleClasses({element: passwordInput, addClass: 'is-invalid', removeClass: 'is-valid'})
                jsErrors.innerHTML = `<p class="error-text small-text">${errors}</p>`
            }
            if(password.isValid){
                ElementFunctions.toggleClasses({element: confirmPasswordInput, addClass: 'is-valid', removeClass: 'is-invalid'})
                ElementFunctions.getSiblingWithClass(confirmPasswordInput, 'js-errors').innerHTML = ""
            }else{
                ElementFunctions.toggleClasses({element: confirmPasswordInput, addClass: 'is-invalid', removeClass: 'is-invalid'})
            }
        })


        confirmPasswordInput.addEventListener('input', function(){
            let value = confirmPasswordInput.value
            password.confirmPassword = value
            let jsErrors = ElementFunctions.getSiblingWithClass(confirmPasswordInput, 'js-errors')
            let errors = password.confirmPasswordFieldErrors
            if(password.isValid){
                ElementFunctions.toggleClasses({element: confirmPasswordInput, addClass: 'is-valid', removeClass: 'is-invalid'})
                jsErrors.innerHTML = errors
            }else{
                ElementFunctions.toggleClasses({element: confirmPasswordInput, addClass: 'is-invalid', removeClass: 'is-valid'})
                jsErrors.innerHTML = `<p class="error-text small-text">${errors}</p>`
            }
            if(password.isValid){
                ElementFunctions.toggleClasses({element: passwordInput, addClass: 'is-valid', removeClass: 'is-invalid'})
                ElementFunctions.getSiblingWithClass(passwordInput, 'js-errors').innerHTML = ""
            }
            
        })
    }

    
})