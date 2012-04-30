module OrderListingsHelper
  def setup_orderable(order_listing)
    order_listing.tap do |ol|
      ol.orderables.build
    end
  end
  
end
