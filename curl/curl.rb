puts `curl -X GET #{address} | tidy -i`
puts `curl -IL GET #{address}`
puts `curl -sL GET #{address}`
puts `curl -sL GET #{address} | grep "<title>"`
puts `curl -sL GET #{address} >> ~/page.html`
puts `curl --silent GET #{address} | grep "<html*" >> ~/page.txt`
puts `curl --silent GET #{address} | grep -v "/<html.*?>[\w\d\s\W\D\S]*<\/html>/i" >> ~/page.txt`


url = "http://fb.com"

html = `curl -sL GET #{url}` #curl 
html = html[/(<html.*?>[\w\d\s\W\D\S]*<\/html>)/im] #within html tag
html.gsub!(/(<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>)/im, "") #remove script tag
html.gsub!(/(<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>)/im, "") #remove style tag
html.gsub!(/(<!--[\s\S]*?-->)/im, "") #remove comments 
html.gsub!(/(<!DOCTYPE[\s\S]*?>)/im, "") #remove doctype
html.gsub!(/(<meta[\s\S]*?>)/im, "") #remove meta tags
html.gsub!(/(<html[\s\S]*?>)|(</html[\s\S]*?>)/im, "") #remove html tags
#html.gsub!(/(<link[\s\S]*?>)/im, "")

out_file = File.new("out.html", "w")
out_file.puts(html)
out_file.close

#remove all links

base = "http://media.pragprog.com/titles/ruby3/code/samples/tutthreads_"

for i in 1..50

  url = "#{ base }#{ i }.rb"
  file = "tutthreads_#{i}.rb"

  File.open(file, 'w') do |f|   
    system "curl -o #{f.path} #{url}"
  end

end
