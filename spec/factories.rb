require 'faker'

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "blahblah@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :product do |product|
  product.name                    "Slicing Tomatoes"
  product.description             "A case of really good stuff"
  product.organic_status          "organic and conventional"
  product.base_organic_price      2000
  product.base_conventional_price 1500
end 

Factory.define :order_list do |order_list|
  order_list.start_date   Time.now + 3.days
  order_list.end_date     Time.now + 5.days
  order_list.due_date     Time.now + 7.days
  order_list.association :user, {:email => Faker::Internet.email}
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
