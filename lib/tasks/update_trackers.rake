require 'rubygems'	
require 'nokogiri'
require 'open-uri'	

desc "Update trackers with new changes."
task :update_trackers => :environment do
	
	if Tracker.all.count > 0
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

						temp = html.css(tagName)
						temp = html if temp.length == 0
						html = temp if temp.length > 0
						
						# if contains attributes, then delete
						temp.each { |node| 
							begin
								node.attributes.each { |name, val| temp.delete(node) }
							rescue
							end					
						}
						temp = html if temp.length == 0
						html = temp if temp.length > 0
						
					elsif (attr_name == "class")

						attr_val.split(" ").each { |klass| #split classes
							temp = html.css("#{tagName}[#{attr_name}='#{klass}']") 
							temp = html.css("#{tagName}[#{attr_name}]") if temp.length == 0
							temp = html.css(tagName) if temp.length == 0
							temp = html if temp.length == 0
							html = temp if temp.length > 0
						}
						
					else #with attributes
						temp = html.css("#{tagName}[#{attr_name}='#{attr_val}']") 
						temp = html.css("#{tagName}[#{attr_name}]") if temp.length == 0
						temp = html.css(tagName) if temp.length == 0
						temp = html if temp.length == 0
						html = temp if temp.length > 0
					end # end if
				} # end of loop

				if (html.length == 1)
					if (t.updates.last.content != html.to_s)
						Update.create(content: html.to_s, tracker_id: t.id)
						ModelMailer.new_update_notification(t, t.updates).deliver
						p "Successfully updated Tracker #{t.id}"
					else
						p "Content Tracker #{t.id} remains unchanged."
					end #end if
					
				elsif html.length > 1
					p "Tracker #{t.id} failed to update. Error: output contains #{html.length} node(s)" 
					p html.each_with_index { |(x), index|
						p index
						p x.to_s
					}
					#create record anyways
					#crate array, then compare with previous record
					
				elsif (html.length == 0)
					p "Tracker #{t.id} failed to update. Error: output contains #{html.length} node(s)" 
				end # end if				
			else
				p "#{all_nodes.length} not divisible by 3."
			end # end if
		end	# end loop
	else
		p "0 records."
	end #end if
end # end task