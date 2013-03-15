class Comment
  include Datamappify::Entity

  attribute :content, String

  relationships do
    belongs_to :user
  end
end
