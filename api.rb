require 'rubygems'
require 'sinatra'
require "sinatra/json"
require 'sinatra/jbuilder'
require 'faker'
require 'slugify'
require 'json'


class Post
  
  @posts = []
  
  
  def initialize
    @filename = 'data-posts.json'
    @posts ||= read_or_create
  end
  
  def read_or_create
    if File.exist?(@filename)
      JSON.parse(File.read @filename)
    else
      populate
    end
  end
  
  def themes(categoryId)
    themes = {
      '0' => 'business',
      '1' => 'people',
      '2' => 'cats',
      '3' => 'city',
      '4' => 'nature',
      '5' => 'abstract',
      '6' => 'fashion',
      '7' => 'abstract',
      '8' => 'business',
      '9' => 'technics',
      '10' => 'nightlife',
      '11' => 'people',
      '12' => 'abstract',
      '13' => 'nature',
      '14' => 'sports',
      '15' => 'abstract'
    }
    themes[categoryId]
  end
  
  def populate
    posts = []
    idx = 0
    4.times do 
      idx += 1
      title = Faker::Lorem.sentence(3)
      url = "http://localhost:5000/img/cid/slider-#{idx}.jpg"
      posts << {id: idx, category_id: 15,  slug: title.slugify, title: title, summary: Faker::Hipster.paragraph(2), featured_image_url: url, author: "#{Faker::Name.first_name} #{Faker::Name.last_name}", published_at: Faker::Date.backward(30).strftime("%b %d, %Y") }
    end
    1000.times do
      idx += 1
      title = Faker::Hipster.sentence(1)
      categoryId = rand(14)
      url = "http://lorempixel.com/#{rand(500)+300}/#{rand(400)+100}/#{themes(categoryId.to_s)}/China-India-Dialogue/?#{rand(10000)}"
      posts << {id: idx, category_id: categoryId,  slug: title.slugify, title: title, summary: Faker::Hipster.paragraph(4), featured_image_url: url, author: "#{Faker::Name.first_name} #{Faker::Name.last_name}", published_at: Faker::Date.backward(30).strftime("%b %d, %Y") }
    end
    
    File.open(@filename,"w") do |f|
      f.write(posts.to_json)
    end
    posts
  end
  
  def all
    @posts
  end
  
  def by_category(categoryId)
   @posts.select{|p| p['category_id'].eql?(categoryId.to_i)}
  end
  
end

get '/posts' do 
  categoryId = params['category_id']
  limit = params['limit'] || 10
  offset = params['offset'] || 0
  @posts = categoryId.nil? ? Post.new.all : Post.new.by_category(categoryId) 
  @posts = @posts[offset.to_i, limit.to_i]
  headers( "Access-Control-Allow-Origin" => "*" )
  jbuilder :posts
end

get '/categories' do
  headers( "Access-Control-Allow-Origin" => "*" )
  jbuilder :categories
end