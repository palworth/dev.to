class UpdateMachineCollections
  def initialize
    update_all_collections
  end

  def update_all_collections
    MachineCollection.all.each do |coll|
      coll.articles << coll.suggested_articles
    end
  end

end
