module Sales
  OrderAlreadyPlaced = Class.new(StandardError)
  MissingOrderItems  = Class.new(StandardError)
end

require_relative 'domain/order'
require_relative 'domain/product'
require_relative 'domain/events'
require_relative 'application/order_application_service'
require_relative 'application/order/place_order_command'
require_relative 'application/order/expire_order_command'
require_relative 'application/order/add_item_to_order_command'
