module OrderListingsHelper
  def setup_orderable(order_listing)
    returning(order_listing) do |ol|
      ol.orderables.build
    end
  end
  
end
