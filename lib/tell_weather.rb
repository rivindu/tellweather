#!/usr/bin/env ruby
require 'net/http'
require 'rexml/document'
require 'open-uri'
include REXML

class TellWeather
  def initialize
  end
  
  def get_woeid(location)
      encoded_location= URI::encode(location)
      url = 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.places%20where%20text%3D%22'+encoded_location+'%22&format=xml'
      xml_data = Net::HTTP.get_response(URI.parse(url)).body
      @xmldoc = Document.new(xml_data)
    
      @xmldoc.elements.each("query/results/place/woeid"){ 
        |e| return e.text
      } 
  end
  
  def get_weather_XML(woeid)
    wurl='http://weather.yahooapis.com/forecastrss?w='+2189783.to_s+'&u=c'
    wxml= Net::HTTP.get_response(URI.parse(wurl)).body
    @weather_XML = Document.new(wxml)
    return @weather_XML
  end
  
  def get_wind_chill(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/yweather:wind"){ 
      |e| return e.attributes["chill"] 
    }
  end
  
  def get_wind_direction(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/yweather:wind"){ 
      |e| return e.attributes["direction"] 
    }
  end
  
  def get_wind_speed(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/yweather:wind"){ 
      |e| return e.attributes["speed"] 
    }
  end
  
  def get_humidity(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/yweather:atmosphere"){ 
      |e| return e.attributes["humidity"] 
    }
  end
  
  def get_pressure(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/yweather:atmosphere"){ 
      |e| return e.attributes["pressure"] 
    }
  end
  
  def get_sunrise(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/yweather:astronomy"){ 
      |e| return e.attributes["sunrise"] 
    }
  end
  
  def get_sunset(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/yweather:astronomy"){ 
      |e| return e.attributes["sunset"] 
    }
  end
  
  def get_latitude(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/item/geo:lat"){ 
      |e| return e.text
    }
  end
  
  def get_longitude(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/item/geo:long"){ 
      |e| return e.text
    }
  end
  
  def get_condition(woeid)
    windxml= get_weather_XML(woeid)
    windxml.elements.each("rss/channel/item/yweather:condition"){ 
      |e| return e.attributes["text"] 
    }
  end
  
end