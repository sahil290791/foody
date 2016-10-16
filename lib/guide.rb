require "restaurant"
require "support/string_extend"

class Guide
	
	class Config
		@@actions = ["add","list","find","quit"]
		def self.actions; @@actions; end
	end

	def initialize(path=nil)
		# locate the restaurant text file
		Restaurant.filepath = path
		# or create a new one
		if Restaurant.file_exists?
			puts "Found restaurant file..\n\n"
		elsif Restaurant.create_file
			puts "Creating restaurant file..\n\n"
		else
			puts "Exiting..\n\n"
			exit!
		end
		# exit if create fails
	end

	def launch!
		introduction
		# action loop
		result = nil
		until result == :quit
			action, args = get_action
			result = do_action(action, args)
		end
		conclusion
	end

	def get_action
		action = nil
		until Guide::Config.actions.include? action
			puts "Actions: #{Guide::Config.actions.join(', ')}\n" if action
			print "> "
			user_response = gets.chomp
			args = user_response.downcase.strip.split(" ")
			action = args.shift
		end	
		return action, args
	end

	def do_action(action, args=[])
		case action
		when "find"
			keyword = args.shift
			find(keyword)
		when "list"
			list(args)
		when "add"
			add
		when "quit"
			puts "Quitting"
			:quit
		else
			puts "I don't understand that command\n\n"
		end
	end

	def find(keyword="")
		output_action_header("Find a Restaurant")
		if keyword
			restaurants = Restaurant.saved_restaurants
			found = restaurants.select do |rest|
				rest.name.downcase.include?(keyword.downcase) ||
				rest.cuisine.downcase.include?(keyword.downcase) || 
				rest.price.to_i <= keyword.to_i
			end
			output_restaurant_table(found)
		else
			puts "Find using a key phrase to search the restaurant list."
			puts "Examples: 'Find Mirchi', 'Find Indian', 'Find ind'\n\n"
		end
	end

	def list(args=[])
		sort_order = args.shift
		sort_order = args.shift if sort_order == "by"
		sort_order = "name" unless ["name","cuisine","price"].include? sort_order
		output_action_header("Listing Restaurants")
		restaurants = Restaurant.saved_restaurants
		restaurants.sort! do |r1, r2|
			case sort_order
			when "name"
				r1.name.downcase <=> r2.name.downcase
			when "cuisine"
				r1.cuisine.downcase <=> r2.cuisine.downcase
			when "price"
				r1.price.to_i <=> r2.price.to_i
			end
		end
		output_restaurant_table(restaurants)
		puts "Sort using: 'list cuisine' or 'list by cuisine'\n\n"
		
	end

	def add
		output_action_header("Add a Restaurant")
		restaurant = Restaurant.build_using_questions
		if restaurant.save
			puts "\n\nRestaurant Added!\n\n"
		else
			puts "\n\nSave Error: Restaurant not added!\n\n"
		end
	end

	def introduction
		puts "\n\n<<<<<< Welcome to the Food Finder >>>>>>>"
		puts "\n\nThis is an interactive guide to help you find food you crave!\n"
	end

	def conclusion
		puts "\n<<<<< Goodbye and Bon Appetit! >>>>>\n\n"
	end

	private

	def output_restaurant_table(restaurants)
		print " Name".ljust(30)
		print " Cuisine".ljust(20)
		print "  Price".ljust(6) +"\n"
		puts "-"*60
		restaurants.each do |rest|
			line = " " << rest.name.titleize.ljust(30)
			line << " " + rest.cuisine.titleize.ljust(20)
			line << " " + rest.formatted_price.ljust(6)
			puts line
		end
		puts "No Restaurants Found\n" if restaurants.empty?
		puts "-"*60
	end

	def output_action_header text
		puts "\n\n#{text.upcase.center(60)}\n\n"
	end
end