class Currency < ActiveRecord::Base
	translates :name

 	def symbol
 		if self.name
	 		if self.name.downcase == 'dollar' || self.name.downcase == 'دلار'
	 			"$"
	 		elsif self.name.downcase == 'euro' || self.name.downcase == 'یورو'
	 			"€"
	 		elsif self.name.downcase == 'pound' || self.name.downcase == 'پوند'
	 			"£"
	 		else
	 			self.name
	 		end 			
 		end
 	end
end
