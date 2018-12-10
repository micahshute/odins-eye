module Reactable
    def likes
        find_reaction_type(:like)
    end

    def dislikes
        find_reaction_type(:dislike)
    end

    def geniuses
        find_reaction_type(:genius)
    end

    def reaction_types_count
        ids = ReactionType.all.map{ |r| r.id }
        count = {}
        ids.each { |r_id| count[r_id] = 0 }
        reactions.each do |reaction|
            count[reaction.reaction_type_id] += 1
        end
        count
    end

    private
    def find_reaction_type(type)
        reactions.select{ |r| r.reaction_type_id == ReactionType.find_by(name: type.to_s).id }.length
    end

end