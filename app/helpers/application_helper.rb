module ApplicationHelper
	
	def table_show_cell(title, value)
		"<tr> 
				<th>
						#{title}
				</th>
				<td>
						#{value} 
				</td>
			</tr>".html_safe unless value.blank?
	end

end
