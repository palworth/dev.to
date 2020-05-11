class ArticleSuggester
  def initialize(article)
    # possibly initialize using collection
    @article = article
  end

  def articles(max: 4)
    # could use this logic and change the max number of articles being displayed
    if article.tag_list.any?
      # avoid loading more data if we don't need to
      tagged_suggestions = suggestions_by_tag(max: max)
      return tagged_suggestions if tagged_suggestions.size == max

      # if there are not enough tagged articles, load other suggestions
      # ignoring tagged articles that might be relevant twice, hence avoiding duplicates
      num_remaining_needed = max - tagged_suggestions.size
      other_articles = other_suggestions(
        max: num_remaining_needed,
        ids_to_ignore: tagged_suggestions.pluck(:id),
      )
      tagged_suggestions.union(other_articles)
    else
      # tests not hitting else statement
      other_suggestions(max: max)
    end
  end

  private
  attr_reader :article

  def other_suggestions(max: 4, ids_to_ignore: [])
    ids_to_ignore << article.id
    Article.published.where(featured: true).
      where.not(id: ids_to_ignore).
      order("hotness_score DESC").
      includes(user: [:pro_membership]).
      offset(rand(0..offsets[1])).
      first(max)
  end
  # looking for articles with the same tags as article being initialized
  def suggestions_by_tag(max: 4)
    Article.published.tagged_with(article.tag_list, any: true).
      where.not(id: article.id).
      order("hotness_score DESC").
      # pro membership depreciated according to https://dev.to/kudapara/what-are-the-perks-that-come-with-a-pro-subscription-to-dev-to-4gh5
      includes(user: [:pro_membership]).
      offset(rand(0..offsets[0])).
      first(max)
  end

  def offsets
    Rails.env.production? ? [10, 120] : [0, 0]
  end
end
