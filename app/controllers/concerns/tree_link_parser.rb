module TreeLinkParser
  extend ActiveSupport::Concern
  require 'net/http'

  def read_json
    url = 'https://random-tree.herokuapp.com/'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
