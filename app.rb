require './convert'

paths = Convert::Source.new
paths.books.each do |book|
	var = Convert::Book.new :path => book
	puts "\n\nbook: #{var.slug}".colorize(:blue)
	var.chapters.each do |chapter|
		converted = Convert::Manipulate.new :file => chapter
		output = Convert::Output.new :source => chapter, :dir => paths.dir, :book => var.slug, :content => converted.markdown
		output.write_file!
	end
end

errors = Convert::Errors.get
if errors > 0
  puts "\nErrors while converting: #{Convert::Errors.get}".colorize(:red)
else
  words = ['congrats','woo hoo',"you're the man", "good going","now to take a break"]
  puts "\nBuild Successful! #{words.sample.capitalize}!".colorize :green
end