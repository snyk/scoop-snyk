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
  sha256 = obj["assets"][bin]["sha256"].split.first

  return url, sha256, version
end

@url, @sha256, @version = get_latest_release()

template = File.read("template.erb")

renderer = ERB.new(template)
puts renderer.result()
