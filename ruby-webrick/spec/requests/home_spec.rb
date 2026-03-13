# ruby-webrick/spec/requests/home_spec.rb
# frozen_string_literal: true

require 'rack/test'
require_relative '../../app'

RSpec.describe 'Home', type: :request do
  include Rack::Test::Methods

  def app
    App.new
  end

  it 'returns a successful response' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.content_type).to include('text/html')
    expect(last_response.body).to include('Howdy, World!')
  end
end
