class ViewStats < Couchbase::Model

  # We want to make sure we use the correct views bucket.
  BUCKET = "views"
  self.bucket = Couch.client :bucket => BUCKET

  view :by_popularity

  def self.popular_content(options={})
    defaults = { :descending => true, :reduce => false, :limit => 1000 }
    options = defaults.merge!(options)
    Couch.client(:bucket => BUCKET).design_docs["view_stats"].by_popularity(options).entries
  end

end