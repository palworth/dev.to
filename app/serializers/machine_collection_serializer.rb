class MachineCollectionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :title,
             :user_id

  attribute :tags, &:tag_list
end
