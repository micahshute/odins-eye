class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reaction_type
  belongs_to :reactable, polymorphic: true

  def self.reported_items
    Reaction.joins(:reaction_type).where(reaction_types: {name: "report"})
  end
end
