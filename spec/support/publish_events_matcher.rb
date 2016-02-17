RSpec::Matchers.define :publish_events do |expected_events|
  match do |event_store|
    event_store.published == expected_events
  end
end
