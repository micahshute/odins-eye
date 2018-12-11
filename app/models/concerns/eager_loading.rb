module EagerLoading
    def eager_load_for(id, *including)
        where(id: id).includes(*including).first
    end
end