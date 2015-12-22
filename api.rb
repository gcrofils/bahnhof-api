require 'rubygems'
require 'sinatra'
require "sinatra/json"
require 'sinatra/jbuilder'
require 'faker'
require 'slugify'
require 'json'
require 'open-uri'


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
  
  def author(authorId)
    
  end
  
  def body
    body = ""
    (1..rand(5)+5).each do |i|
      level = rand(3)+1
      body += "<h#{level}>#{Faker::Lorem.sentence(3)}</h#{level}>"
      (1..rand(5)+1).each do |j|
        body += "<p>#{Faker::Hipster.paragraph(rand(4) + 5)}</p>"
      end
    end
    body
  end
  
  def populate
    posts = []
    idx = 0
    4.times do 
      idx += 1
      title = Faker::Lorem.sentence(3)
      url = "/img/cid/slider-#{idx}.jpg"
      posts << {
        id: idx, 
        category_id: 15,  
        slug: title.slugify, 
        title: title, 
        summary: Faker::Hipster.paragraph(2), 
        featured_image_url: url, 
        author_id: rand(3)+1, 
        author_twitter:"#{Faker::Name.first_name}#{Faker::Name.last_name}",
        author: "#{Faker::Name.first_name} #{Faker::Name.last_name}", 
        published_at: Faker::Date.backward(30),
        image_width: 800,
        image_height: 504,
        body: body}
    end
    300.times do
      idx += 1
      title = Faker::Hipster.sentence(1)
      categoryId = rand(14)
      width = rand(300)+1000
      height = rand(600)+300
      #url = "http://192.168.0.145:9292/image/#{width}/#{height}/#{themes(categoryId.to_s)}"
      url = "http://lorempixel.com/#{width}/#{height}/#{themes(categoryId.to_s)}/China-India-Dialogue/?#{rand(10000)}"
      posts << {
        id: idx, 
        category_id: categoryId,  
        slug: title.slugify, 
        title: title, 
        summary: Faker::Hipster.paragraph(4), 
        featured_image_url: url, 
        author_id: rand(3)+1, 
        author_twitter:"#{Faker::Name.first_name}#{Faker::Name.last_name}",
        author: "#{Faker::Name.first_name} #{Faker::Name.last_name}", 
        published_at: Faker::Date.backward(30),
        image_width: width,
        image_height: height,
        body: body}
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
  
  def by_id(postId)
    @posts.select{|p| p['id'].eql?(postId.to_i)}
  end
  
  def by_slug(slugId)
    @posts.select{|p| p['slug'].eql?(slugId)}
  end
  
end

get '/posts/:slugId' do
  @post = Post.new.by_slug(params['slugId'])
  headers( "Access-Control-Allow-Origin" => "*" )
  jbuilder :post
end

# get '/posts/:postId' do
#   @post = Post.new.by_id(params['postId'])
#   headers( "Access-Control-Allow-Origin" => "*" )
#   jbuilder :post
# end

get '/posts' do
  if params['q']
    posts = []
    params['q'].split('|').each do |item|
      categoryId, lim = item.split(',') 
      p = Post.new.by_category(categoryId)
      (posts << p[0, lim.to_i]).flatten!  
    end
    limit = posts.size
    offset = 0
    @posts = posts
  else
    categoryId = params['category_id']
    limit = params['limit'] || 10
    offset = params['offset'] || 0
    posts = categoryId.nil? ? Post.new.all : Post.new.by_category(categoryId) 
    @posts = posts[offset.to_i, limit.to_i]
  end
  headers["x-pagination"] = {
    total: posts.size,
    total_pages: posts.size / limit.to_i,
    current_page: (offset.to_i / limit.to_i) + 1,
    offset: offset
    }.to_json
  headers( "Access-Control-Allow-Origin" => "*" )
  headers( "Access-Control-Expose-Headers" => "x-pagination")
  jbuilder :posts
end

get '/categories' do
  sleep 3
  headers( "Access-Control-Allow-Origin" => "*" )
  jbuilder :categories
end

get '/image/:width/:height/:theme' do
  is_thumb = params['thumb'] || false
  url = "http://lorempixel.com/#{params['width']}/#{params['height']}/#{params['theme']}/China-India-Dialogue/?#{rand(10000)}"
  send_file open(url), type: 'image/jpeg', disposition: 'inline'
end