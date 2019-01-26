class JSONRequestManager{


    constructor(url, { method = "GET", body = null, authToken = Rails.csrfToken(), form = null } = {}){
        this.url = url;
        this.method = method.toUpperCase();
        if(body) this._body = JSON.stringify(body)
        this.contentType = "application/json";
        this.accepts = 'application/json';
        this.authToken = authToken;
        if(!!form){
            this.formElement = form
            this.form = new FormData(form)
            this._body = this.form
            this.contentType = null
        }
    }

    get headers(){
        let headers = {
            "Accept": this.accepts
        }
        if(this.authToken){
            headers = {
                ...headers, 
                "X-CSRF-Token": this.authToken
            }
        }
        if(this.contentType){
            headers = {...headers, "Content-Type": this.contentType }
        }
        return headers;
    }

    get body(){
        if(this._body) return JSON.parse(this._body)
    }

    set body(bodyObj){
        this._body = JSON.stringify(bodyObj);
    }

    async afetch(){
        const res = await fetch(this.url, {
            method: this.method,
            body: this._body,
            headers: this.headers,
            credentials: "same-origin"
        });
        return await res.json()
    }

    async send(suc, err){ 
        try{
            const res = await fetch(this.url, {
                    method: this.method,
                    body: this._body,
                    headers: this.headers,
                    credentials: "same-origin"
            });
            if(!suc) return res
            const data = await res.json();
            suc(data)
        } catch(error){
            if(!err) return error
            err(error)
        }
    }

    pfetch(){
        return fetch(this.url, {
                method: this.method,
                body: this._body,
                headers: this.headers,
                credentials: "same-origin"
        });
    }

    debugComm(){
        let res = fetch(this.url, {
            method: this.method,
            body: this._body,
            headers: this.headers,
            credentials: "same-origin"
        });
        return {
            success: (cb) => { 
                res.then((res) => res.text()).then(json => cb(json));
                return { error: (cb) => { res.catch(er => cb(er))}  }
            },
            error: (cb) => { res.catch(er => cb(er)) }
        }
    }

    comm(){
        let res = fetch(this.url, {
            method: this.method,
            body: this._body,
            headers: this.headers,
            credentials: "same-origin"
        });
        return {
            success: (cb) => { 
                res.then((res) => res.json()).then(json => cb(json));
                return { error: (cb) => { res.catch(er => cb(er))}  }
            },
            error: (cb) => { res.catch(er => cb(er)) }
        }
    }

}