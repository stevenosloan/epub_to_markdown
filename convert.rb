require 'html2md'
require 'colorize'

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

	class Errors
		@count = 0
		def self.add(count)
			@count += count
		end
		def self.get
			@count
		end
	end

	class Manipulate

		def initialize args
			args.each do |k,v|
				instance_variable_set("@#{k}", v) unless v.nil?
			end
		end

		def markdown
			# strip out xml nastiness
			file_contents = IO.read(@file).gsub '<?xml version="1.0" encoding="utf-8"?>', ''
			begin
				parsed_md = Html2Md.new(file_contents).parse

				# replace definetion lists with markdown-parsable formatting
				parsed_md.gsub! '<dt>', '### '
				parsed_md.gsub! '</dt>', ''
				parsed_md.gsub! '<dd>', "\n"
				parsed_md.gsub! '</dd>', ''
			rescue Exception => e
				puts ">> error converting file: #{@file}".colorize :red
				puts "   message: #{e.message}".colorize :red
				puts "   details: #{e.backtrace.join("\n   ")}".colorize :red
				Convert::Errors.add 1
			end
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

			puts ">> writing chapter to: #{self.path}".colorize(:green)
			FileUtils.mkdir_p( File.dirname( self.path ) )
			File.open( self.path, 'w' ) do |f|
				f.puts @content
			end
		end

	end

end