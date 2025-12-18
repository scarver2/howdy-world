#!/usr/bin/env ruby
# frozen_string_literal: true

require "thor"
require "thor/actions"
require "active_support/core_ext/string/inflections"

require_relative "lib/howdy_builder/csv_reader"
require_relative "lib/howdy_builder/validator"

module HowdyBuilder
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("templates", __dir__)
    end

    desc "scaffold", "Generate nginx, docker-compose, and docs from _builder/languages.csv"
    method_option :csv, type: :string, default: File.expand_path("languages.csv", __dir__)
    method_option :root, type: :string, default: File.expand_path("..", __dir__), desc: "Project root"
    def scaffold
      reader = HowdyBuilder::CsvReader.new(csv_path: options[:csv])

      begin
        HowdyBuilder::Validator.new(reader: reader).validate!
      rescue HowdyBuilder::ValidationError => e
        say_status :error, "CSV validation failed:", :red
        e.message.split("\n").each { |line| say("  - #{line}", :red) }
        exit 1
      end

      services = reader.active_services
      grouped  = reader.grouped_active_services_by_category

      generate_nginx(services: services, grouped: grouped)
      generate_conf_d(services: services)
      generate_index(grouped: grouped)
      generate_compose(services: services)

      say_status :ok, "Generation complete.", :green
    end

    private

    def root_path(*parts)
      File.join(options[:root], *parts)
    end

    def generate_nginx(services:, grouped:)
      empty_directory root_path("nginx")
      template "nginx.conf.erb", root_path("nginx", "nginx.conf")
    end

    def generate_conf_d(services:)
      conf_root = root_path("nginx", "conf.d")
      empty_directory conf_root

      services.each do |svc|
        next unless %w[proxy fastcgi static].include?(svc[:service_type]) # runtime endpoints

        template "nginx.location.conf.erb",
                 File.join(conf_root, "#{svc[:slug]}.conf"),
                 {
                   slug: svc[:slug],
                   display_name: svc[:display_name],
                   service_name: svc[:service_name],
                   port: svc[:port]
                 }
      end
    end

    def generate_index(grouped:)
      www_root = root_path("nginx", "www")
      empty_directory www_root

      template "index.html.erb",
               File.join(www_root, "index.html"),
               { grouped: grouped }
    end

    def generate_compose(services:)
      template "docker-compose.yml.erb", root_path("docker-compose.yml"), { services: services }
    end
  end
end

HowdyBuilder::CLI.start(ARGV)
