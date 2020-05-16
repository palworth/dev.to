class MachineCollection < ApplicationRecord
  belongs_to :user
  has_many :machine_collection_articles, dependent: :destroy
  has_many :articles, through: :machine_collection_articles

  acts_as_taggable_on :tags
  resourcify

  validates :title, :tag_list, presence: true

  def suggested_articles
  ArticleSuggester.new(nil, self).machine_articles(max: 10)
  end
end
