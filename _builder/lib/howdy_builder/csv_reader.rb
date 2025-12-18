# frozen_string_literal: true

require "csv"
require "active_support/core_ext/string/inflections"

module HowdyBuilder
  class CsvReader
    DEFAULT_PORTS = {
      "go" => "8080",
      "java" => "8080",
      "prolog" => "8080",
      "ruby" => "3000",
      "ruby-on-rails" => "3000",
      "rust" => "8080"
    }.freeze

    def initialize(csv_path:)
      @csv_path = csv_path
    end

    def rows
      @rows ||= CSV.read(@csv_path, headers: true).map(&:to_h)
    end

    # Canonical service hashes used by Thor + RSpec.
    def services
      @services ||= rows.map { |r| normalize_row(r) }.compact
    end

    def active_services
      services.select { |s| s[:active] }
    end

    def grouped_active_services_by_category
      active_services
        .group_by { |s| s[:category] }
        .transform_values { |items| items.sort_by { |s| s[:display_name].downcase } }
        .sort_by { |(cat, _)| cat.to_s.downcase }
        .to_h
    end

    private

    def normalize_row(r)
      language  = clean(r["language"])
      framework = clean(r["framework"])

      return nil if language.empty?

      display_name =
        if framework.empty?
          language
        else
          "#{language} (#{framework})"
        end

      slug =
        if framework.empty?
          language.parameterize
        else
          "#{language}-#{framework}".parameterize
        end

      service_name = "#{slug}-app"

      service_type       = clean(r["service_type"]).downcase
      category           = clean(r["category"]).downcase
      runtime_dependency = clean(r["runtime_dependency"]).downcase
      docker_template    = clean(r["docker_template"]).downcase
      language_type      = clean(r["language_type"]).downcase
      url                = clean(r["url"])
      notes              = clean(r["notes"])

      active = clean(r["active"]).downcase == "yes"

      port = clean(r["port"])
      if port.empty? && active && %w[fastcgi proxy].include?(service_type)
        port = DEFAULT_PORTS[slug] || ""
      end

      {
        language: language,
        framework: framework,
        display_name: display_name,
        slug: slug,
        service_name: service_name,
        service_type: service_type,
        category: category,
        runtime_dependency: runtime_dependency,
        port: port,
        docker_template: docker_template,
        active: active,
        language_type: language_type,
        url: url,
        notes: notes
      }
    end

    def clean(v)
      v.to_s.strip
    end
  end
end
