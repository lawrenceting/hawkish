rails g scaffold Product name:string
rails g scaffold Tracker url:string selector:string product:references
rails g scaffold Modification date:datetime price:decimal tracker:references

cd Sites/hawkish
rails s

rails d scaffold Product
rails g scaffold Group name:string

whenever -w --set environment=development

heroku ps --app hawkish
heroku logs --ps web.1 --app hawkish
heroku logs --app hawkish
heroku logs --tail --app hawkish
heroku logs --tail --ps scheduler.3395 --app hawkish
heroku run rake update_trackers --app hawkish

str = @tracker.selector.gsub(/(<[^>]*>)/im, "") #remove all tags

- dont remove css, remove when clicked, 
- confirm track $16.99
# check for valid url
# OpenURI::HTTPError: 503 Service Unavailable
get url hostname
create new heroku application then use sub branch, then merge when ready


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

# to do: change content to array of nodes as string 