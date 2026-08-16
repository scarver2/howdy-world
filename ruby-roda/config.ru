# ruby-roda/config.ru
# frozen_string_literal: true

require_relative "app"

run App.freeze.app
