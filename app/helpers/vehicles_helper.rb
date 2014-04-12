module VehiclesHelper

	def t_has h
		if h == true
			t('has')
		else
			t('dosnt_have')
		end
	end


end
