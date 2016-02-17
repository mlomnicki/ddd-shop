require 'spec_helper'

RSpec.describe Sales::Domain::Order::Order do
  let(:aggregate_id) { 1 }
  let(:customer_id)  { 12 }
  let(:product_id)   { 5 }

  subject { described_class.new(aggregate_id) }

  describe "#create" do
    it "creates an order" do
      subject.add_item(product_id)
      subject.create(customer_id)

      expect(subject).to raise_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id),
        Sales::Domain::Order::OrderCreated.new(order_id: aggregate_id, customer_id: customer_id)
      ])
    end

    it "does not allow to create an empty order" do
      expect { subject.create(customer_id) }.to raise_error(described_class::MissingItems)
    end

    it "does not allow to create an already created order" do
      subject.add_item(product_id)
      subject.create(customer_id)

      expect { subject.create(customer_id) }.to raise_error(described_class::AlreadyCreated)
    end
  end

  describe "#add_item" do
    it "adds an item to the order" do
      subject.add_item(product_id)

      expect(subject).to raise_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id)
      ])
    end

    it "does not allow to add items to created order" do
      subject.add_item(product_id)
      subject.create(customer_id)

      expect { subject.add_item(product_id) }.to raise_error(described_class::AlreadyCreated)
    end
  end
end