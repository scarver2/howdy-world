# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Howdy World endpoints' do
  xit 'serves the dashboard at /', pending: 'pending implementation' do
    res = http_get('/')
    expect(res.code.to_i).to eq(200)
    expect(res.body).to include('Howdy World')
  end

  ACTIVE_WEB.each do |svc|
    xit "serves #{svc[:display_name]} at /#{svc[:slug]}/", pending: 'pending implementation' do
      res = http_get("/#{svc[:slug]}/")
      expect(res.code.to_i).to eq(200), "Expected 200, got #{res.code}. Body:\n#{res.body}"
      expect(res.body.to_s.strip.length).to be > 0
    end
  end
end
