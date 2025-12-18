# frozen_string_literal: true

module HowdyBuilder
  class ValidationError < StandardError; end

  class Validator
    REQUIRED_COLUMNS = %w[
      active
      category
      docker_template
      framework
      language
      language_type
      notes
      port
      runtime_dependency
      service_type
      url
    ].freeze

    SERVICE_TYPES = %w[
      cli
      fastcgi
      nonserviceable
      proxy
      static
    ].freeze

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
        assert_in!(s, :service_type, SERVICE_TYPES)
        assert_in!(s, :category, CATEGORIES)
        assert_in!(s, :runtime_dependency, RUNTIME_DEPENDENCIES)

        if s[:active]
          if s[:service_type] == "nonserviceable"
            @errors << "#{s[:slug]}: active=yes but service_type=nonserviceable"
          end

          if %w[fastcgi proxy].include?(s[:service_type]) && blank?(s[:port])
            @errors << "#{s[:slug]}: active=yes but port is blank"
          end

          if blank?(s[:docker_template])
            @errors << "#{s[:slug]}: active=yes but docker_template is blank"
          end
        end
      end
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

    def blank?(v)
      v.nil? || v.to_s.strip.empty?
    end
  end
end
