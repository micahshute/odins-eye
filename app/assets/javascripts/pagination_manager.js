class PaginationManager{

    constructor({nextBtn = null, prevBtn = null, dataContainer = null, baseUrl, perPage = null, totalItems = Number.POSITIVE_INFINITY, customPrevDisabledTest = () => false, customNextDisabledTest = () => false, includeSpinner = true} = {}){
        this.nextBtn = nextBtn || document.querySelector('.nextBtn')
        this.prevBtn = prevBtn || document.querySelector('.prevBtn')
        this.dataContainer = dataContainer || document.querySelector('.pagination-data-container')
        this.baseUrl = baseUrl
        this.perPage = perPage 
        this.totalItems = totalItems
        this.urlParamsMan = URLParamsManager
        this.activeBtn = null
        if(!this.perPage){
            this.perPage = parseInt(this.nextBtn.dataset.perpage) || parseInt(this.prevBtn.dataset.perpage)
        }
        this.customNextDisabledTest = customNextDisabledTest
        this.customPrevDisabledTest = customPrevDisabledTest
        this.includeSpinner = includeSpinner

    }



    get inactiveBtn(){
        if(this.activeBtn === this.nextBtn){
            return this.prevBtn
        }else{
            return this.activeBtn
        }
    }

    get offset(){
        this.verifyClick()
        return this.activeBtn.dataset.offset
    }

    get url(){
        this.verifyClick()
        const paramsManager = new this.urlParamsMan({
            offset: this.offset,
            per_page: this.perPage
        })
        return paramsManager.getUrl(this.baseUrl)
    }

    async getData(){
        const req = new JSONRequestManager(this.url)
        try{
            return await req.afetch()
        }catch(e){
            this.error(e)
        }
    }

    initialize(){
        if((this.prevBtn && (parseInt(this.perPage) >= this.totalItems) || this.customPrevDisabledTest())){
            ElementFunctions.addClass({element: this.prevBtn, klass: "disabled"})
        }else{
            ElementFunctions.removeClass({element: this.prevBtn, klass: 'disabled'})
        }
        if(this.nextBtn && (this.nextBtn.dataset.offset === "0" || this.customNextDisabledTest())){
            ElementFunctions.addClass({element: this.nextBtn, klass: "disabled"})
        }
    }


    justClick(btn){
        if(btn === "next" || btn === this.nextBtn){
            this.activeBtn = this.nextBtn
        }else if(btn === "prev" || btn === this.prevBtn){
            this.activeBtn = this.prevBtn
        }else{
            throw "Invalid button sent to PaginationManager"
        }
    }

    async relaod(){
        if(this.includeSpinner){
            this.renderSpinner()
        }
        let offset
        if(this.nextBtn.classList.contains('disabled')){
            offset = 0
        }else{
            offset = this.nextBtn.dataset.offset + this.perPage
        }
        const pm = new this.urlParamsMan({
            offset: offset,
            per_page: this.perPage
        })
        const url = pm.getUrl(this.baseUrl)
        console.log(this.baseUrl)
        const req = new JSONRequestManager(url)
        try{
            const data = await req.afetch()
            return data
        }catch(e){
            this.error(e)
        }
    }

    async click(btn){
        if(this.includeSpinner){
            this.renderSpinner()
        }
        this.justClick(btn)
        const data = await this.getData()
        if(data.data && data.data.length > 0) this.totalItems = parseInt(data.data[0].meta['count'])
        this.updateButtons()
        return data
    }

    renderSpinner(){
        this.renderedSpinner = document.createElement('div')
        this.renderedSpinner.className = 'loader center'
        this.dataContainer.insertAdjacentElement('beforeend', this.renderedSpinner)
    }

    removeSpinner(){
        if(this.renderedSpinner){
            this.renderedSpinner.remove()
            this.renderedSpinner = null
        }
    }

    verifyClick(){
        if(!this.activeBtn) throw "No button has been clicked"
    }

    error(e){
        const flashMessage = new FlashMessage('danger', e)
        flashMessage.render()
        this.removeSpinner()
    }

    updateButtons(){
        this.verifyClick()
        if(this.activeBtn === this.prevBtn){
            console.log("active is prev")
            if((parseInt(this.offset) + parseInt(this.perPage) >= this.totalItems) || this.customPrevDisabledTest()){
                ElementFunctions.addClass({element: this.prevBtn, klass: "disabled"})
                console.log('disable prev btn')
            }else{ 
                const intOffset = parseInt(this.offset)
                this.prevBtn.setAttribute('data-offset', (intOffset + this.perPage).toString())
                console.log(`update prev button offset to ${intOffset + this.perPage}`)
            }
            
            if(this.nextBtn.classList.contains('disabled')){
                this.nextBtn.classList.remove('disabled')
                this.nextBtn.setAttribute('data-offset', "0")
                console.log('enable next btn')
            }else{
                const newOffset = parseInt(this.nextBtn.dataset.offset)
                this.nextBtn.setAttribute('data-offset', (newOffset + parseInt(this.perPage)).toString())
                console.log(`update next btn offset ${newOffset + this.perPage}`)
            }

        }else{
            if(this.nextBtn.dataset.offset === "0" || this.customNextDisabledTest()){
                ElementFunctions.addClass({element: this.nextBtn, klass: "disabled"})
            }else{
                const intOffset = parseInt(this.offset)
                this.nextBtn.setAttribute('data-offset', (intOffset - parseInt(this.perPage)).toString())
            }

            if(this.prevBtn.classList.contains('disabled')){
                this.prevBtn.classList.remove('disabled')
            }else{
                const oldOffset = parseInt(this.prevBtn.dataset.offset)
                this.prevBtn.setAttribute('data-offset', (oldOffset - parseInt(this.perPage)).toString())
            }
        }
    }


}