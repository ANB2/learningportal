class TopContributorsJob

  CONTRIBUTORS_LIMIT = 8

  def initialize(limit=CONTRIBUTORS_LIMIT)
    @limit = limit
  end

  def perform
    @top_contribs = []

    @contributors = Author.bucket.design_docs["author"].by_contribution_count({ :descending => true, :group => true }).entries
    @contributors.each do |row|
      author = Author.new(:name => row.key, :contributions_count => row.value)
      @top_contribs << author
    end

    @top_contribs.sort! {|a,b| a.contributions_count <=> b.contributions_count}
    @top_contribs.reverse!
    @top_contribs = @top_contribs.take(@limit)
    @top_contribs.map! { |contrib| contrib.to_json }

    Couch.client(:bucket => "system").set("contributors", {:contributors => @top_contribs})
  end

end