module TopicHelper

    def editing?(topic)
        !topic.new_record?
    end
end