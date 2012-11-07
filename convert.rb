require 'nokogiri'
require 'reverse_markdown'

module Convert

	class Source

		def initialize
			@dir = File.join( Dir.pwd, 'source' )
		end

		def dir
			@dir
		end

		def books
			Dir[ File.join( @dir, '**' )] 
		end

	end

	class Book
		attr_reader :name

		def initialize args
			args.each do |k,v|
				instance_variable_set("@#{k}", v) unless v.nil?
			end
		end

		def slug
			File.basename( @path )
		end

		def chapters
			Dir[ File.join( @path, 'OEBPS', '*.html' )]
		end
	end

	class Manipulate

		def initialize args
			args.each do |k,v|
				instance_variable_set("@#{k}", v) unless v.nil?
			end
		end

		def markdown
			ReverseMarkdown.parse Nokogiri::HTML( File.open( @file ) ).at_css ".content"
		end

	end

	class Output
	
		def initialize args
			@dir = args[:dir].gsub( 'source' , 'output' )
			@source = args[:source]
			@book = args[:book]
			@content = args[:content]
		end

		def path
			filename = File.join( File.basename( @source ).gsub(".html", ".md") )
			@path = File.join( @dir, @book, filename )
		end

		def write_file!
			require 'fileutils'
			
			puts ">> writing chapter to: #{self.path}"
			FileUtils.mkdir_p( File.dirname( self.path ) )
			File.open( self.path, 'w' ) do |f|
				f.puts @content
			end
		end

	end

end