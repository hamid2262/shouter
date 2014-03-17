module SearchSubtripsHelper

	def extract_city address
		address.split(',').first
	end
end