require 'csv'
require 'faker'

# Clear existing data
puts 'Clearing existing data...'
OrderItem.destroy_all if defined?(OrderItem)
Order.destroy_all if defined?(Order)
Product.destroy_all
Category.destroy_all
Province.destroy_all

# Provinces
puts 'Creating provinces...'
Province.create!(name: 'Alberta', abbreviation: 'AB', gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)
Province.create!(name: 'British Columbia', abbreviation: 'BC', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00)
Province.create!(name: 'Manitoba', abbreviation: 'MB', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00)
Province.create!(name: 'New Brunswick', abbreviation: 'NB', gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: 'Newfoundland and Labrador', abbreviation: 'NL', gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: 'Nova Scotia', abbreviation: 'NS', gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: 'Ontario', abbreviation: 'ON', gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.13)
Province.create!(name: 'Prince Edward Island', abbreviation: 'PE', gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: 'Quebec', abbreviation: 'QC', gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.00)
Province.create!(name: 'Saskatchewan', abbreviation: 'SK', gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.00)
Province.create!(name: 'Northwest Territories', abbreviation: 'NT', gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)
Province.create!(name: 'Nunavut', abbreviation: 'NU', gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)
Province.create!(name: 'Yukon', abbreviation: 'YT', gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)

# Categories (now 4 instead of 2)
puts 'Creating categories...'
Category.create!(name: 'Cakes', description: 'Custom celebration cakes for every occasion, available in a variety of sizes and flavours.')
Category.create!(name: 'Cupcakes', description: 'Delicious cupcakes available by the dozen in rotating seasonal flavours.')
Category.create!(name: 'Cookies', description: 'Fresh baked cookies made daily with real butter and quality ingredients.')
Category.create!(name: 'Pastries', description: 'Flaky croissants, danishes, and morning pastries baked fresh every morning.')

# Load 20 hand-written products from CSV (feature 1.8)
puts 'Loading products from db/products.csv...'
CSV.foreach(Rails.root.join('db', 'products.csv'), headers: true) do |row|
  category = Category.find_by(name: row['category'])
  Product.create!(
    name: row['name'],
    description: row['description'],
    price: row['price'].to_f,
    available: true,
    on_sale: row['on_sale'] == 'true',
    sale_price: row['sale_price'].presence&.to_f,
    category: category
  )
end

# Generate more products with Faker to reach 100+ (feature 1.6)
puts 'Generating additional products with Faker to reach 100...'
flavours = [
  'Vanilla Bean', 'Dark Chocolate', 'Salted Caramel', 'Lemon Curd',
  'Raspberry', 'Maple', 'Espresso', 'Pistachio', 'Coconut', 'Blueberry',
  'Cinnamon', 'Hazelnut', 'Orange Blossom', 'Brown Sugar', 'Matcha',
  'Lavender', 'Pumpkin Spice', 'Honey', 'Chai', 'Peanut Butter'
]

forms = {
  'Cakes' => ['Layer Cake', 'Bundt Cake', 'Cheesecake', 'Sheet Cake', 'Loaf Cake'],
  'Cupcakes' => ['Cupcake', 'Mini Cupcake', 'Filled Cupcake'],
  'Cookies' => ['Cookie', 'Sandwich Cookie', 'Shortbread', 'Biscotti'],
  'Pastries' => %w[Danish Scone Tart Turnover Croissant]
}

while Product.count < 100
  category = Category.all.sample
  name = "#{flavours.sample} #{forms[category.name].sample}"
  next if Product.exists?(name: name)

  base_price = category.name == 'Cakes' ? rand(28.0..52.0) : rand(2.5..7.5)
  is_on_sale = [true, false, false, false].sample

  Product.create!(
    name: name,
    description: Faker::Food.description,
    price: base_price.round(2),
    available: true,
    on_sale: is_on_sale,
    sale_price: is_on_sale ? (base_price * 0.8).round(2) : nil,
    category: category
  )
end

# Stagger timestamps so "new" and "recently updated" filters have data (feature 2.4)
puts 'Staggering timestamps for filter demo data...'
all_products = Product.order(:id).to_a

# First 10 products: created in last 2 days (these are "new")
all_products[0, 10].each do |product|
  stamp = rand(1..2).days.ago
  product.update_columns(created_at: stamp, updated_at: stamp)
end

# Next 10 products: created long ago but updated recently (these are "recently updated" but not "new")
all_products[10, 10].each do |product|
  product.update_columns(created_at: 45.days.ago, updated_at: rand(1..2).days.ago)
end

# Remaining products: old created and old updated
all_products[20..].each do |product|
  stamp = rand(30..90).days.ago
  product.update_columns(created_at: stamp, updated_at: stamp)
end

# Re-create the test customer account
puts 'Creating test customer...'
if defined?(User)
  User.find_or_create_by!(email: 'lou@vannas.com') do |user|
    user.password = 'password123'
    user.password_confirmation = 'password123'
    user.province = Province.find_by(abbreviation: 'MB')
  end
end

puts "Done! #{Product.count} products across #{Category.count} categories, #{Province.count} provinces."
puts "On sale: #{Product.where(on_sale: true).count}"

puts 'Creating tags...'
['Bestseller', 'Seasonal', 'Nut-Free', 'Vegan', 'Gluten-Free', 'Party Favourite'].each do |name|
  Tag.find_or_create_by(name: name)
end
puts "Tags: #{Tag.pluck(:name).join(', ')}"
