require 'faker'

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "blahblah@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
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
  order_list.association :user, {:email => Faker::Internet.email}
end

 Factory.sequence :email do |n|
   "person-#{n}@example.com"
 end

Factory.define :orderable do |orderable|
  orderable.product            Factory(:product)
  orderable.order_list         Factory(:order_list)
  orderable.organic_price      10.00
  orderable.conventional_price 8.00
end


