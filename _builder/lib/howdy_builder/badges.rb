# frozen_string_literal: true

# HowdyBuilder::Badges centralizes small presentational helpers
# so templates stay declarative and simple.
#
# Badges are intentionally short and consistent for:
# - docs/README.md index
# - docs/<slug>/README.md
# - future HTML dashboards
module HowdyBuilder
  module Badges
    module_function

    # Returns a compact array of badge strings like:
    # ["family:jvm", "category:functional", "service:proxy", "runtime:jvm", "active:yes"]
    def badges_for(svc)
      b = []
      b << "family:#{svc[:language_family]}" if svc[:language_family].present?
      b << "category:#{svc[:category]}" if svc[:category].present?
      b << "service:#{svc[:service_type]}" if svc[:service_type].present?
      b << "runtime:#{svc[:runtime_dependency]}" if svc[:runtime_dependency].present?
      b << "active:#{svc[:active] ? 'yes' : 'no'}"
      b
    end

    # Returns an array of hashes so HTML can render cleanly:
    # [{ key: "family", value: "jvm" }, ...]
    def badge_pairs_for(svc)
      pairs = []
      pairs << { key: 'family', value: svc[:language_family] } if svc[:language_family].present?
      pairs << { key: 'category', value: svc[:category] } if svc[:category].present?
      pairs << { key: 'service', value: svc[:service_type] } if svc[:service_type].present?
      pairs << { key: 'runtime', value: svc[:runtime_dependency] } if svc[:runtime_dependency].present?
      pairs << { key: 'active',  value: (svc[:active] ? 'yes' : 'no') }
      pairs
    end

    # Render badges as HTML spans. Keep this tiny and style via CSS.
    def html_badges(svc)
      badge_pairs_for(svc).map do |p|
        %(<span class="badge badge-#{p[:key]}">#{p[:key]}:#{p[:value]}</span>)
      end.join(' ')
    end

    # Markdown badge rendering (simple bracketed tags).
    # Example: `[family:jvm] [service:proxy]`
    def markdown_badges(svc)
      badges_for(svc).map { |t| "[#{t}]" }.join(' ')
    end
  end
end
