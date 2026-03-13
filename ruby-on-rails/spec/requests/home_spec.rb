# ruby-on-rails/spec/requests/home_spec.rb
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  it 'returns a successful response' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.content_type).to include('text/html')
    expect(last_response.body).to include('Howdy, World!')
  end
end
