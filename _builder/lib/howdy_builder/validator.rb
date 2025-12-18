# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module HowdyBuilder
  class ValidationError < StandardError; end

  class Validator
    CATEGORIES = %w[
      compiled
      framework
      functional
      interpreted
      logic
      markup
      platform
      scripting
      tooling
      vm
    ].freeze

    LANGUAGE_FAMILIES = %w[
      academic
      assembly
      beam
      business
      dotnet
      educational
      enterprise
      functional
      hpc
      javascript
      jvm
      markup
      native
      platform
      scientific
      tooling
      unix
      web
    ].freeze

    REQUIRED_COLUMNS = %w[
      active
      category
      docker_template
      framework
      language
      language_family
      language_type
      notes
      port
      runtime_dependency
      service_type
      url
    ].freeze

    RUNTIME_DEPENDENCIES = %w[
      beam
      browser
      dotnet
      jvm
      node
      none
      php
      proprietary
      python
      ruby
      tooling
    ].freeze

    SERVICE_TYPES = %w[
      cli
      fastcgi
      nonserviceable
      proxy
      static
    ].freeze

    def initialize(reader:)
      @reader = reader
      @errors = []
    end

    def validate!
      validate_headers!
      validate_rows!
      validate_uniqueness!
      raise ValidationError, @errors.join("\n") if @errors.any?

      true
    end

    private

    def validate_headers!
      headers = @reader.rows.first&.keys || []
      missing = REQUIRED_COLUMNS - headers
      @errors << "CSV missing required columns: #{missing.join(', ')}" if missing.any?
    end

    def validate_rows!
      @reader.services.each do |s|
        assert_in!(s, :category, CATEGORIES)
        assert_in!(s, :language_family, LANGUAGE_FAMILIES)
        assert_in!(s, :runtime_dependency, RUNTIME_DEPENDENCIES)
        assert_in!(s, :service_type, SERVICE_TYPES)

        next unless s[:active]

        validate_servicable(s)
        validate_service_port(s)
        validate_javascript_consistency(s)
        validate_language_and_framework_cells(s)
        validate_docker_template_cell(s)
      end
    end

    def validate_service_port(service)
      return unless %w[fastcgi proxy].include?(service[:service_type]) && blank?(service[:port])

      @errors << "#{service[:slug]}: active=yes but port is blank"
    end

    def validate_javascript_consistency(service)
      if service[:framework].present? &&
         service[:runtime_dependency] == 'node' &&
         service[:language] != 'JavaScript'
        @errors << "#{service[:slug]}: JavaScript frameworks must use language=JavaScript"
      end
    end

    def validate_servicable(service)
      return unless service[:service_type] == 'nonserviceable'

      @errors << "#{service[:slug]}: active=yes but service_type=nonserviceable"
    end

    def validate_port(service)
      return unless %w[fastcgi proxy].include?(service[:service_type]) && blank?(service[:port])

      @errors << "#{service[:slug]}: active=yes but port is blank"
    end

    # Header-row leakage detection
    def validate_language_and_framework_cells(service)
      return unless service[:language] == 'language' && service[:framework] == 'framework'

      @errors << 'CSV contains a header row inside data'
    end

    # Docker template cell validation
    def validate_docker_template_cell(service)
      return unless blank?(service[:docker_template])

      @errors << "#{service[:slug]}: active=yes but docker_template is blank"
    end

    def validate_uniqueness!
      slugs = @reader.services.map { |s| s[:slug] }
      dupes = slugs.group_by(&:itself).select { |_k, v| v.size > 1 }.keys
      @errors << "Slug collision(s): #{dupes.join(', ')}" if dupes.any?
    end

    def assert_in!(service, field, allowed)
      value = service[field]
      return unless blank?(value) || !allowed.include?(value)

      @errors << "#{service[:slug]}: invalid #{field}=#{value.inspect} (allowed: #{allowed.join(', ')})"
    end

    def blank?(value)
      value.nil? || value.to_s.strip.empty?
    end
  end
end
