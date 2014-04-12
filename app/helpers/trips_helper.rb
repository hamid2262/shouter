module TripsHelper

	def title_create stage, current_stage, text
		if stage == 6
			img = "#{IMAGES_PATH}check-mark.png"
		else
			img = "#{IMAGES_PATH}arrow-#{lang_other_side}.png"
		end
		if stage == current_stage
			html = <<-HTML
				<td class="\stage current-stage\">	
					<strong> #{text} </strong>
					<img src="#{img}" alt="check-mark" class="pull-#{lang_other_side}">
				</td>
			HTML
		else
			html = <<-HTML
				<td class="stage">
					#{text}
				</td>
			HTML
		end
		html.html_safe 
	end

	def apropriate_currency
		if params[:locale] != "fa" || session[:date_format] == 'miladi'
			3
		else
			1
		end
	end

end