require 'ddd_ecommerce'
require 'support/fake_event_store'
require 'support/receive_events_matcher'
require 'support/raise_events_matcher'
require 'sales/sales'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
