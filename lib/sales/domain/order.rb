require_relative 'order_item'

module Sales
  module Domain
    class Order
      include AggregateRoot

      attr_reader :id

      def initialize(id)
        @id       = id
        @state    = :draft
        @items    = []
        @discount_amount = Money.zero
      end

      def add_item(product_id, price)
        check_if_draft
        apply ItemAddedToOrder.new(order_id: id, price: price, product_id: product_id)
      end

      def place(customer_id)
        check_if_draft
        check_if_items_available
        apply OrderPlaced.new(order_id: id, customer_id: customer_id, total_price: total_price)
      end

      def complete
        check_if_placed
        apply OrderCompleted.new(order_id: id)
      end

      def expire
        check_if_draft
        apply OrderExpired.new(order_id: id)
      end

      def cancel(reason)
        apply OrderCancelled.new(order_id: id, reason: reason)
      end

      def apply_discount(amount)
        check_if_draft
        apply DiscountApplied.new(order_id: id, amount: amount)
      end

      private

      attr_accessor :state, :customer_id, :items, :discount_amount

      def apply_order_placed(_event)
        @state = :placed
      end

      def apply_order_expired(_event)
        @state = :expired
      end

      def apply_order_completed(_event)
        @state = :completed
      end

      def apply_order_cancelled(_event)
        @state = :cancelled
      end

      def apply_item_added_to_order(event)
        @items << OrderItem.new(event.product_id, event.price)
      end

      def apply_discount_applied(event)
        @discount_amount = event.amount
      end

      def total_price
        items.map(&:price).reduce(Money.zero, :+) - discount_amount
      end

      def check_if_draft
        raise OrderAlreadyPlaced unless state == :draft
      end

      def check_if_placed
        raise OrderNotPlaced unless state == :placed
      end

      def check_if_items_available
        raise MissingOrderItems if items.empty?
      end
    end
  end
end
