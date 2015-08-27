require 'rubygems'	
require 'nokogiri'
require 'open-uri'	

desc "Update trackers with new changes."
task :update_trackers => :environment do
	
	Tracker.all.each do |t|
		begin
			html = Nokogiri::HTML(open(t.url))
			nodes = t.nodes.split("[split]").reverse()
			count = nodes.length

			nodes.in_groups_of(3) do |grp|
				count -= 3
				attr_val = grp[0]
				attr_name = grp[1]
				tagName = grp[2].downcase

				begin
					if attr_name == "[no_attr_name]" # if no attributes
						html = html.css(tagName)

						# if contains attributes, then delete
						html.each { |node| 
							begin
								node.attributes.each { |name, val| html.delete(node) }
							rescue
							end					
						}

					else #with attributes
						html = html.css("#{tagName}[#{attr_name}='#{attr_val}']") 
					end
				rescue
					html = html.css(tagName) #last resort, get nodes with tag name
					puts "Error! Unable to parse html with attributes, resorted to parsing tagname: " + grp.join(" | ")
				end		

				#ensure last node does not have children
				html.each { |node| 
					begin
						html.delete(node) if node.element_children.length > 0
					rescue
					end							
				} if count == 0 #if end of loop
			end		

			if html.length == 1
				Modification.create(date: DateTime.now, content: html.text.strip, tracker_id: t.id)
			else
				puts "Error: more than 1 node." 
			end
			
		rescue
			puts "Tracker #{t.id} failed to update."
		end			
	end	
end