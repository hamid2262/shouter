module TripsHelper
	def options_for_year 
		options_for_select( 1392..1393, JalaliDate.new(Date.today).year)
	end

	def options_for_month
		options_for_select(	[ 
													['فروردین', 1], ['اردیبهشت', 2], 
													['خرداد', 3], ['تیر', 4], 
													['مرداد', 5], ['شهریور', 6], 
													['مهر', 7], ['آبان', 8], 
													['آذر', 9], ['دی', 10], 
													['بهمن', 11], ['اسفند', 12] 
												]	, JalaliDate.new(Date.today).month)		
	end		 

	def options_for_day
		options_for_select(1..31 , JalaliDate.new(Date.today).day)		
	end		 

	def options_for_hour
		options_for_select ("00".."24")
	end		 

	def options_for_minute
		options_for_select ['00','15','30','45']
	end		 
end