require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sass'
require 'coffee-script'
require 'net/http'
require 'logger'
require 'json'
require 'dotenv'
require 'amazon/ecs'
Dotenv.load

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  # routingの設定
  get '/' do
    Amazon::Ecs.configure do |options|
     options[:AWS_access_key_id] = ENV["AWS_ACCESS_KEY"]
     options[:AWS_secret_key] = ENV["AWS_SECRET_KEY"]
     options[:associate_tag] = 'ykykamazon-22'
     options[:country] = 'jp'
    end

     Amazon::Ecs.debug = true

    @res = Amazon::Ecs.item_search('ジャケット', response_group: 'Medium', search_index: 'Apparel', item_page: 1)
    if @res.is_valid_request?
      #@res.items.each do |item|
      #  item.get('ASIN')
      #  item.get('ItemAttributes/Title')

      #  item_attributes = item.get_element('ItemAttributes')
      #  item_attributes.get('Title')
      #end
    end
    slim :index
  end
end

