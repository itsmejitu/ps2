require 'nokogiri'
require 'open-uri'

html_data = ('https://ait.ac.th/')
doc = Nokogiri::HTML(open (html_data))
p doc.css ('.media-object')


