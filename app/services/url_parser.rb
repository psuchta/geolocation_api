class UrlParser
  # Returns core part of the url | Example:  http://www.wp.pl -> wp.pl
  #
  # @param url [String] url of a website
  # @return [Hash] normalized url
  def self.trim_url(url)
    # Normalization
    uri = Addressable::URI.parse(url)
    url = uri.normalize.to_s

    # Add any protocol if it doesn't exist
    url = "http://#{url}" unless uri.scheme

    # Many similar steps but it was the only fast way
    uri = Addressable::URI.parse(url)
    uri.domain.to_s.presence || url
  end
end
