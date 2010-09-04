require 'rubygems'
require 'httparty'
require 'cgi'
require 'sinatra'
require 'json'

class Wikipedia
  include HTTParty
  headers "User-Agent" => "Wikiassociation (+http://abscond.org/)"
  def self.backlinks_for(title)
    response = get("http://en.wikipedia.org/w/api.php?action=query&format=json&list=backlinks&bltitle=#{title}")
    all_backlinks = response.parsed_response["query"]["backlinks"]
    backlinks = []
    all_backlinks.each do |backlink|
      backlinks << backlink if backlink["ns"] == 0
    end
    backlinks
  end
  
  def self.categories_for(title)
    response = get("http://en.wikipedia.org/w/api.php?action=query&format=json&titles=#{title}&prop=categories")
    categories = response.parsed_response["query"]["pages"].collect do |page|
      page[1]["categories"].collect{|x| x["title"]}
    end
    categories.first
  end
  
  def self.is_associated_with?(title, association)
    self.categories_for(title).each do |category|
      return true if category =~ /#{association}/
    end
    return false
  end
  
  def self.things_associated_with(thing, type)
    results = []
    self.backlinks_for(thing).each do |backlink_item|
      backlinked_title = CGI.escape(backlink_item["title"])
      results << backlink_item["title"] if self.is_associated_with?(backlinked_title, type)
    end
    results
  end
  
  def self.find_school_by_ofsted(ofsted_number)
    response = get("http://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=ofsted%20#{ofsted_number}")
    response.parsed_response["query"]["search"][0]["title"]
  end
end

get '/things_associated_with' do
  Wikipedia.things_associated_with(params[:name], params[:topic]).to_json
end

get '/school_from_ofsted' do
  Wikipedia.find_school_by_ofsted(params[:ofsted_number])
end
