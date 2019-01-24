class ApiController < ApplicationController

    def check_email
        body = JSON.parse(request.body.read)
        email = body["email"]
        user = User.find_by(email: email)
        if !!user
            render json: JSON.generate({data: true})
        else
            render json: JSON.generate({data: false})
        end
    end
end