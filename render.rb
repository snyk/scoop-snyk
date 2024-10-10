#! /usr/bin/env ruby

#
# This script grabs the latest release details for Snyk CLI
# and then generates a scoop manifest.
#

require "erb"
require "json"
require "open-uri"

# Return the URL, SHA and version information for the latest release
def get_latest_release()
  bin = "snyk-win.exe"
  snyk_cli_version_url = "https://downloads.snyk.io/cli/latest/release.json"
  data = URI.parse(snyk_cli_version_url).read
  obj = JSON.parse(data)
  version = obj["version"]
  url = obj["assets"][bin]["url"]

  # Parse the URL and add the utm parameter
  uri = URI.parse(url)
  new_query_ar = URI.decode_www_form(uri.query || '') << ["utm_source", "SCOOP"]
  uri.query = URI.encode_www_form(new_query_ar)
  url_with_utm = uri.to_s + "#/snyk-win.exe"

  sha256 = obj["assets"][bin]["sha256"].split.first

  return url_with_utm, sha256, version
end

@url, @sha256, @version = get_latest_release()

template = File.read("template.erb")

renderer = ERB.new(template)
puts renderer.result()
