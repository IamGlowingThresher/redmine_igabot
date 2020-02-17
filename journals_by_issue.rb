require "uri"
require "net/http"
require 'json'

class JournalsByIssue
  def initialize(eva_issue)
    url = URI("http://192.168.1.248:9000/redmine/issues/#{eva_issue}.json?include=journals")
    https = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["X-Redmine-API-Key"] = "2814a2f2fa27477c8afaa33ab73a2ebfc583544b"
    @journals = JSON.parse(https.request(request).read_body)["issue"]["journals"]
  end
  def journals
    @journals
  end
end

