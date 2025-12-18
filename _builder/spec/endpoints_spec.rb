# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe "Howdy World endpoints" do
  it "serves the dashboard at /" do
    res = http_get("/")
    expect(res.code.to_i).to eq(200)
    expect(res.body).to include("Howdy World")
  end

  ACTIVE_WEB.each do |svc|
    it "serves #{svc[:display_name]} at /#{svc[:slug]}/" do
      res = http_get("/#{svc[:slug]}/")
      expect(res.code.to_i).to eq(200), "Expected 200, got #{res.code}. Body:\n#{res.body}"
      expect(res.body.to_s.strip.length).to be > 0
    end
  end
end
