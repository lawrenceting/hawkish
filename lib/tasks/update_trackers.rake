require 'rubygems'	
require 'nokogiri'
require 'open-uri'	

desc "Update trackers with new changes."
task :update_trackers => :environment do
	
	Tracker.all.each do |t|
		html = Nokogiri::HTML(open(t.url))
		all_nodes = t.nodes.split("[split]")
		new_nodes = [];

		if all_nodes.length % 3 == 0
			
			all_nodes.in_groups_of(3) { |tagName, attr_name, attr_val|
				new_nodes.push(tagName.downcase, attr_name, attr_val)
				break if attr_name == 'id'
			}
			
			new_nodes.reverse.in_groups_of(3).each_with_index { |(attr_val, attr_name, tagName), index|

				if (attr_name == "[no_attr_name]") && (attr_val == "[no_attr_val]") # if no attribute name and value
					
					html = html.css(tagName)

					# if contains attributes, then delete
					html.each { |node| 
						begin
							node.attributes.each { |name, val| html.delete(node) }
						rescue
						end					
					}

				elsif (attr_name != "[no_attr_name]") && (attr_val == "[no_attr_val]") # if no attribute value
					
					html = html.css("#{tagName}[#{attr_name}]")
					
				else #with attributes
					
					temp = html.css("#{tagName}[#{attr_name}='#{attr_val}']") 

					if temp.length == 0
						temp = html.css("#{tagName}[#{attr_name}]")
						html = (temp.length == 0) ? html.css(tagName) : temp
					else
						html = temp
					end # end if
				
				end # end if

				#ensure last node does not have children
				html.each { |node| 
					begin
						html.delete(node) if node.element_children.length > 0
					rescue
					end							
				} if new_nodes.length/3-1 == index #if end of loop
			} # end of loop
				
			if (html.length == 1)
				
				if (t.updates.last.content != html.text.strip)
					
					Update.create(date: DateTime.now, content: html.text.strip, tracker_id: t.id)
					ModelMailer.new_update_notification(t, t.updates).deliver
					p "Successfully updated Tracker #{t.id}"
					
				else
					p "Content Tracker #{t.id} remains unchanged."
				end
				
			else
				p "Tracker #{t.id} failed to update."
				p "Error: output contains #{html.length} node(s)" 
				p html
			end # end if				

		else
			p "#{all_nodes.length} not divisible by 3."
		end # end if
	end	# end loop
end # end task