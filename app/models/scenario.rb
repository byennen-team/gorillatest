class Scenario

 include Mongoid::Document

 field :name, type: String

 embedded_in :feature

 embeds_many :steps

 def serializable_hash(options={})
   {
     id: id.to_s,
     name: name,
     project_id: feature.project.id.to_s
   }
 end

end
