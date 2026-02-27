# ruby-rage/spec/requests/home_spec.rb
# frozen_string_literal: true

require "rage/rspec"

RSpec.describe "Home", type: :request do
  it "returns a successful response" do
    get "/"

    expect(response).to have_http_status(:ok)
    expect(response.content_type).to include("text/html")
    expect(response.body).to include("Howdy, World!")
  end
end