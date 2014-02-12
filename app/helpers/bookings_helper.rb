module BookingsHelper
	
	def status_indicator status
		if status == 0
			content_tag(:button, t("waiting"), class: "btn  btn-sm btn-warning status_indicator", disabled: "disabled")
		elsif status == 1
			content_tag(:button,t("accepted"), class: "btn  btn-sm btn-success status_indicator", disabled: "disabled")
		elsif status == -1
			content_tag(:button,t("rejected"), class: "btn  btn-sm btn-danger status_indicator", disabled: "disabled")				
		end
	end

end
