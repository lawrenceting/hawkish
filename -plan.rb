rails g scaffold Product name:string
rails g scaffold Tracker url:string selector:string product:references
rails g scaffold Update date:datetime content:string tracker:references
rails d scaffold Group

rails g mailer model_mailer new_update_notification

cd Sites/hawkish
rails s

whenever -w --set environment=development

heroku ps --app hawkish
heroku logs --ps web.1 --app hawkish
heroku logs --app hawkish
heroku logs --tail --app hawkish
heroku logs --tail --ps scheduler.3395 --app hawkish
heroku run rake update_trackers --app hawkish

str = @tracker.selector.gsub(/(<[^>]*>)/im, "") #remove all tags

@html = `curl -sL GET #{url}` #curl 
@html = @html[/(<html.*?>[\w\d\s\W\D\S]*<\/html>)/im] #within & including html tag
@html.gsub!(/(<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>)/im, "") #remove script tag
@html.gsub!(/(<!\-\-[^\-\->]*\-\->)/im, "") #remove comments 
@html.gsub!(/(<meta[\s\S]*?>)/im, "") #remove meta tags
@html.gsub!(/(<html[\s\S]*?>)|(<\/html[\s\S]*?>)/im, "") #remove html tags

out_file = File.new("out.html", "w")
out_file.puts(@html)
out_file.close	

html = html.css(tagName + "." + attrib_val.gsub(' ', '.')) 
	
rails g migration RemoveDetailsFromModifications price

## to do: ##
change content to array of nodes as string 
- dont remove css, remove when clicked, 
- confirm track $16.99
# check for valid url
# OpenURI::HTTPError: 503 Service Unavailable
get url hostname
create new heroku application then use sub branch, then merge when ready
					
#if temp.length == 0
#	(attr_val.length).downto(1) { |i|
#		temp = html.xpath("//#{tagName}[starts-with(@#{attr_name}, '#{attr_val[0,i]}')]")
#		break if temp.length > 0
#	} # end of loop
#
#	temp.each { |node| 
#		begin
#			html.delete(node) if node["#{attr_name}"].length != attr_val.length
#		rescue
#		end							
#	}	