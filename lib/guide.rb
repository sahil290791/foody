require "restaurant"

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
			action = get_action
			result = do_action(action)
		end
		conclusion
	end

	def get_action
		action = nil
		until Guide::Config.actions.include? action
			puts "Actions: #{Guide::Config.actions.join(', ')}\n" if action
			print "> "
			user_response = gets.chomp
			action = user_response.downcase.strip
		end	
		return action
	end

	def do_action(action)
		case action
		when "find"
			puts "Finding.."
		when "list"
			list
		when "add"
			add
		when "quit"
			puts "Quitting"
			:quit
		else
			puts "I don't understand that command\n\n"
		end
	end


	def list
		puts "Listing Restaurants\n\n".upcase
		restaurants = Restaurant.saved_restaurants
		restaurants.each do |rest|
			puts rest.name + " | " + rest.cuisine + " | " + rest.price
		end
	end

	def add
		puts "Add a Restaurant\n\n".upcase
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
end