class Restaurant

	attr_accessor :name, :cuisine, :price
	@@filepath = nil


	def initialize(args={})
		@name    = args[:name]    || "" 
		@cuisine = args[:cuisine] || ""
		@price   = args[:price]   || ""
	end

	def self.filepath=(path=nil)
		@@filepath = File.join(APP_ROOT, path)
	end

	def self.file_exists?
		# should know if the restaurant file exists
		if @@filepath and File.exists?(@@filepath)
			return true
		else
			return false
		end
	end

	def self.build_using_questions
		args = {}	
		print "Restaurant name: "
		args[:name] = gets.chomp.strip

		print "Cuisine Type: "
		args[:cuisine] = gets.chomp.strip

		print "Average Price: "
		args[:price] = gets.chomp.strip

		return self.new(args)
	end

	def self.file_usable?
		return false unless @@filepath
		return false unless File.exists?(@@filepath)
		return false unless File.readable?(@@filepath)
		return false unless File.writable?(@@filepath)
		return true
	end

	def save
		return false unless Restaurant.file_usable?
		File.open(@@filepath, "a") do |file|
			file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
		end
		return true
	end

	def self.create_file
		# create the restaurant file
		File.open(@@filepath,'w') unless file_exists?
		return file_usable?
	end

	def self.saved_restaurants
		restaurants = []
		if file_usable?
			file = File.open(@@filepath, "r")
			file.each_line do |line|
				restaurants << Restaurant.new.import_line(line.chomp)
			end
			file.close
		end
		return restaurants
	end

	def import_line line
		line_array = line.split("\t")
		@name, @cuisine, @price = line_array
		return self
	end

end