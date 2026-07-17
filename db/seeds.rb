# Clear existing data
puts "Clearing existing data..."
Product.destroy_all
Category.destroy_all
Province.destroy_all

# Categories
puts "Creating categories..."
cakes = Category.create!(
  name: "Cakes",
  description: "Custom celebration cakes for every occasion, available in a variety of sizes and flavours."
)

cupcakes = Category.create!(
  name: "Cupcakes",
  description: "Delicious cupcakes available by the dozen in rotating seasonal flavours."
)

# Products
puts "Creating products..."

# Cakes
Product.create!(name: "Classic Vanilla Birthday Cake", description: "A light and fluffy vanilla sponge cake layered with buttercream frosting and rainbow sprinkles. Perfect for birthdays.", price: 55.00, category: cakes, available: true)
Product.create!(name: "Dark Chocolate Fudge Cake", description: "Rich dark chocolate cake layers filled with chocolate ganache and finished with a smooth fudge frosting.", price: 60.00, category: cakes, available: true)
Product.create!(name: "Strawberry Lemonade Cake", description: "Bright and zesty lemon sponge filled with fresh strawberry jam and lemon buttercream. A summer favourite.", price: 58.00, category: cakes, available: true)
Product.create!(name: "Salted Caramel Cake", description: "Moist brown sugar cake layers filled with house-made salted caramel sauce and whipped caramel buttercream.", price: 62.00, category: cakes, available: true)
Product.create!(name: "Tiered Wedding Cake", description: "Elegant three-tier white cake decorated with fresh florals and ribbon. Feeds up to 80 guests. Custom orders welcome.", price: 350.00, category: cakes, available: true)
Product.create!(name: "Carrot Cake", description: "A warmly spiced carrot cake packed with walnuts and raisins, finished with thick cream cheese frosting.", price: 55.00, category: cakes, available: true)
Product.create!(name: "Red Velvet Celebration Cake", description: "Classic red velvet layers with a hint of cocoa, filled and frosted with tangy cream cheese icing.", price: 60.00, category: cakes, available: true)

# Cupcakes
Product.create!(name: "Classic Vanilla Cupcakes", description: "Soft vanilla cupcakes topped with a swirl of vanilla buttercream and a dusting of sprinkles. Sold by the dozen.", price: 36.00, category: cupcakes, available: true)
Product.create!(name: "Chocolate Lovers Cupcakes", description: "Double chocolate cupcakes with a chocolate ganache centre and dark chocolate buttercream. Sold by the dozen.", price: 38.00, category: cupcakes, available: true)
Product.create!(name: "Lemon Raspberry Cupcakes", description: "Tangy lemon cupcakes with a fresh raspberry compote swirled into the buttercream. Sold by the dozen.", price: 40.00, category: cupcakes, available: true)
Product.create!(name: "Maple Bacon Cupcakes", description: "A Winnipeg favourite. Fluffy maple cupcakes topped with maple buttercream and a crispy candied bacon crumble.", price: 42.00, category: cupcakes, available: true)
Product.create!(name: "Mini Cupcake Party Box", description: "An assortment of 24 mini cupcakes in a mix of our most popular flavours. Perfect for events and parties.", price: 45.00, category: cupcakes, available: true)

# Provinces
puts "Creating provinces..."
Province.create!(name: "Alberta", abbreviation: "AB", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)
Province.create!(name: "British Columbia", abbreviation: "BC", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00)
Province.create!(name: "Manitoba", abbreviation: "MB", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00)
Province.create!(name: "New Brunswick", abbreviation: "NB", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: "Newfoundland and Labrador", abbreviation: "NL", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: "Nova Scotia", abbreviation: "NS", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: "Ontario", abbreviation: "ON", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.13)
Province.create!(name: "Prince Edward Island", abbreviation: "PE", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15)
Province.create!(name: "Quebec", abbreviation: "QC", gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.00)
Province.create!(name: "Saskatchewan", abbreviation: "SK", gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.00)
Province.create!(name: "Northwest Territories", abbreviation: "NT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)
Province.create!(name: "Nunavut", abbreviation: "NU", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)
Province.create!(name: "Yukon", abbreviation: "YT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00)

puts "Done! Created #{Category.count} categories, #{Product.count} products, #{Province.count} provinces."