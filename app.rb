require './convert'

paths = Convert::Source.new

paths.books.each do |book|
	var = Convert::Book.new :path => book
	puts "\n\nbook: #{var.slug}"
	var.chapters.each do |chapter|
		converted = Convert::Manipulate.new :file => chapter
		output = Convert::Output.new :source => chapter, :dir => paths.dir, :book => var.slug, :content => converted.markdown
		output.write_file!
	end
end