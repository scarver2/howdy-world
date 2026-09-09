# ruby-kino/kino.rb
# frozen_string_literal: true

port Integer(ENV.fetch("PORT", 3000))
mode :ractor
