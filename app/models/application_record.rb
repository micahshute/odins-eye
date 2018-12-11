class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def edited?
    self.created_at != self.updated_at
  end
  
end
