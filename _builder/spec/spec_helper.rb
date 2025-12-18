# frozen_string_literal: true

require 'net/http'
require 'uri'

require_relative '../lib/howdy_builder/csv_reader'

RSpec.configure do |config|
  config.order = :defined
end

def base_url
  ENV.fetch('HOWDY_BASE_URL', 'http://localhost:8080')
end

def http_get(path)
  uri = URI.join(base_url, path)
  Net::HTTP.start(uri.host, uri.port, open_timeout: 3, read_timeout: 10) do |http|
    http.get(uri.request_uri)
  end
end

READER = HowdyBuilder::CsvReader.new(csv_path: File.expand_path('../languages.csv', __dir__))
ACTIVE_WEB = READER.active_services.select { |s| %w[fastcgi proxy static].include?(s[:service_type]) }
