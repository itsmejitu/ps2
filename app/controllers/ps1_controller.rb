require 'nokogiri'
require 'open-uri'

class Ps1Controller < ApplicationController
  
  def divide
  	begin
	b = 80/0 

  	rescue => e
  	puts e.backtrace
  	@backtrace = e.backtrace	
  	
  	end

  end

def parse
	require 'nokogiri'
    require 'open-uri'

    html_data = ('https://ait.ac.th/')
    doc = Nokogiri::HTML(open (html_data))

     @aitNews = []
     

    media_obj = doc.css('.media-object')
    media_obj.each do |x|
    	news = AitNews.new()
    	news.url = x.attribute('href').text
    	news.title = x.children.attribute('alt').text
    	news.image = x.children.attribute('src').text
    	@aitNews.push(news)
    	p @aitNews
    end
  end
end