rails g scaffold Product name:string
rails g scaffold Tracker url:string selector:string Product:references
rails g scaffold Modification date:datetime price:decimal Tracker:references

cd Sites/price-tracker
rails s

rails d scaffold Product
rails g scaffold Group name:string

whenever -w --set environment=development

heroku ps --app hawkish
heroku logs --ps web.1 --app hawkish

str = @tracker.selector.gsub(/(<[^>]*>)/im, "") #remove all tags

- deploy to heroku to see if scheduler works
- grouping
- dont remove css, remove when clicked, 
- confirm track $16.99
#check for valid url
# OpenURI::HTTPError: 503 Service Unavailable
	#delete unused column

@html = `curl -sL GET #{url}` #curl 
@html = @html[/(<html.*?>[\w\d\s\W\D\S]*<\/html>)/im] #within & including html tag
@html.gsub!(/(<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>)/im, "") #remove script tag
@html.gsub!(/(<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>)/im, "") #remove style tag
@html.gsub!(/(<!\-\-[^\-\->]*\-\->)/im, "") #remove comments 
@html.gsub!(/(<!DOCTYPE[\s\S]*?>)/im, "") #remove doctype
@html.gsub!(/(<meta[\s\S]*?>)/im, "") #remove meta tags
@html.gsub!(/(<html[\s\S]*?>)|(<\/html[\s\S]*?>)/im, "") #remove html tags
@html.gsub!(/(<link[\s\S]*?>)/im, "")

out_file = File.new("out.html", "w")
out_file.puts(@html)
out_file.close	

elsif attrib_name == 'class' #class
	html = html.css(tagName + "." + attrib_val.gsub(' ', '.')) 
	
	rails g migration RemoveDetailsFromModifications price