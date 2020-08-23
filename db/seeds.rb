Product.destroy_all

product_numbers = [*1..8]

product_numbers.each do |num|
  Product.create(
    name: "Product name_#{num}",
    brand: "Product brand_#{num}",
    price: "$#{num}00.00",
    description: "Product description_#{num}"
  )
end

puts "Optional visual feedback when it finishes seeding."
puts "=================================================="
puts "                    SEEDED"
puts "=================================================="