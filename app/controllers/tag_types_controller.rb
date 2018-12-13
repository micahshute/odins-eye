class TagTypesController < ApplicationController

    def index
        @tags = TagType.all
    end
end