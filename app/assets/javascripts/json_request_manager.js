class JSONRequestManager{


    constructor(url, { method = "GET", body = null, authToken = window._token } = {}){
        this.url = url;
        this.method = method.toUpperCase();
        if(body) this._body = JSON.stringify(body)
        this.contentType = "application/json";
        this.accepts = 'application/json';
        this.authToken = authToken;
        const auth_elem = document.querySelector('[name="authenticity_token"]');
        if(auth_elem){
            this.authToken = auth_elem.value;
        }
    }

    get headers(){
        let headers = {
            "Accept": this.accepts,
            "Content-Type": this.contentType,
            "credentials": "same-origin"
        }
        if(this.authToken){
            headers = {
                ...headers, 
                "X-CSRF-Token": this.authToken
            }
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
            body: this.body,
            headers: this.headers
        });
        return await res.json()
    }

    async send(suc, err){ 
        try{
            const res = await fetch(this.url, {
                    method: this.method,
                    body: this.body,
                    headers: this.headers
            });
            if(!suc) return res
            const data = await res.json();
            suc(data)
        } catch(error){
            if(!err) return error
            err(error)
        }
    }

    pFetch(){
        return fetch(this.url, {
                method: this.method,
                body: this.body,
                headers: this.headers
        });
    }

    comm(){
        let res = fetch(this.url, {
            method: this.method,
            body: this.body,
            headers: this.headers
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