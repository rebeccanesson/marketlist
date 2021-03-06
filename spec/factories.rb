require 'faker'

Factory.sequence :email do |n|
  u = User.find(:first, :order => "id ASC")
  x = (u ? u.id : 0)
  res = "factory_#{x}@example.com"
  puts res
  res
end

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 Faker::Internet.email
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.organic               false
  user.address_1             "19 Corporal Burns Road"
  user.city                  "Cambridge"
  user.state                 "MA"
  user.zipcode               "02138"
  user.phone                 "617-111-1111"
end

Factory.define :product_family do |product_family|
  product_family.name       Faker::Name.name
end

Factory.define :product do |product|
  product.name                    "Slicing Tomatoes"
  product.description             "A case of really good stuff"
  product.product_family          Factory(:product_family, {:name => Faker::Name.name})
end 

Factory.define :order_list do |order_list|
  order_list.order_start    Time.zone.now + 3.days
  order_list.order_end      Time.zone.now + 5.days
  order_list.delivery_start Time.zone.now + 7.days
  order_list.delivery_end   Time.zone.now + 7.days + 5.hours
  order_list.user           Factory(:user, :email => Faker::Internet.email)
end

Factory.define :order_listing do |order_listing|
  order_listing.order_list      Factory(:order_list)
  order_listing.product_family  Factory(:product_family)
  order_listing.quantity        3
end

Factory.define :orderable do |orderable|
  orderable.product            Factory(:product)
  orderable.order_listing      Factory(:order_listing)
  orderable.organic_price      10.00
  orderable.conventional_price 8.00
end

Factory.define :commitment do |commitment|
  commitment.orderable    Factory(:orderable)
  commitment.user         Factory(:user, :email => Faker::Internet.email)
  commitment.quantity     1
end

Factory.define :invoice do |invoice|
  invoice.user         Factory(:user, :email => Faker::Internet.email)
  invoice.order_list   Factory(:order_list)
end


