# -*- coding: utf-8 -*-

require 'rubygems'

begin
	require '/home/ubuntu/.rvm/gems/ruby-2.1.2@yesweb/gems/ckip_client-0.0.7/lib/CKIP_Client.rb'
rescue LoadError
	require 'ckip_client'	
end

require 'nokogiri'
require 'open-uri'
require 'webrick/httputils'


def getQuote(input)	
	dict = File.readlines('Uni_TW_CP950')
	result = CKIP.segment(input, 'neat')
	ans = result.split('　')
	#print ans
	#puts ""
	freq = Hash.new
	ans.each do |word| 
		#puts "testing " + word
		dict.each do |str|
			pair = str.split("\t")
			if pair[0] == word
				#puts "got it the freq is " + pair[1]
				freq[word] = pair[1].to_i
				break
			end
		end
	end
	print freq.sort_by {|_key, value| value}
	puts ""
	puts getLyricFromKKBOX(freq.min_by{|k,v| v}.first)	

end

def getLyricFromKKBOX(keyword)

    begin
		#puts "keyword is " + keyword
        url = "http://www.kkbox.com/tw/tc/search.php?search=lyrics&word="
        query = url+keyword
        query.force_encoding('binary')
        query=WEBrick::HTTPUtils.escape(query)
        page = Nokogiri::HTML(open(query))

        name = page.css("div.search-result").css("ul.lyrics").css("li")
		random = Random.rand(0...10)
        song_name = name[random].css("a")[0].text
		puts "song_name : " + song_name
        lyrics = page.css("div.full-lyrics.switch")[random]
		lyrics.search('br').each do |n|
			n.replace("\n")
		end
		paragraph = lyrics.text.split("\n")
		paragraph.each do |text|
			if text.include? keyword
				puts text.lstrip
				break
			end
		end
        puts getLinkFromYouTube(song_name)
        #response = "#{name[0].text}\n#{lyrics[0].text.split("\n")[3].lstrip}\n#{thelink}"
		response = ""
    rescue => error
        response = ""
    end
    return response
end

def getLinkFromYouTube(name)
    begin
        youtube = "http://www.youtube.com/results?search_query="
        query = youtube+name
        query.force_encoding('binary')
        query=WEBrick::HTTPUtils.escape(query)
        page = Nokogiri::HTML(open(query))
        links = page.css("a.yt-uix-sessionlink.yt-uix-tile-link.spf-link.yt-ui-ellipsis.yt-ui-ellipsis-2")
        i = 0
        while links[i]["href"].index("/watch")!=0
            i+=1
        end
        thelink = "http://www.youtube.com" + links[i]["href"]
    rescue => error
        puts error.message
    end
    return thelink
end




input = ARGV[0]
getQuote(input)
