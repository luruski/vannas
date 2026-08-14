tags = ['Bestseller', 'Seasonal', 'Nut-Free', 'Vegan', 'Gluten-Free', 'Party Favourite']

tags.each do |name|
  Tag.find_or_create_by(name: name)
end

puts "Tags created: #{Tag.pluck(:name).join(', ')}"

puts 'Creating tags...'
['Bestseller', 'Seasonal', 'Nut-Free', 'Vegan', 'Gluten-Free', 'Party Favourite'].each do |name|
  Tag.find_or_create_by(name: name)
end
puts "Tags: #{Tag.pluck(:name).join(', ')}"
