class ImagesController < ApplicationController
  require 'net/http'
  require 'json'
# This method call when we call home page
  @zip_code
  def index

    @json_response = get_response
    @array = []
    @options = []
    @json_response.each do |foo|
      # @array.push(foo['hero_1600x565_url'])
      @options.push(foo['name'])
    end
  end

# This is method which is called by AJAX request and based selected parameter will give the response
  def child_images
    puts params[:select_value]
    json_response = get_response
    select_val = []
    urls = []
    chaild_images = []
    json_response.each do |foo|
      if foo['name'] == params[:select_value]
        puts foo['name']
        foo['gallery_images'].each do |f|
          select_val << f['name']
          urls << f['img_url']
        end
      end
    end
    # rendering the response
    options = {'options' => select_val,
               'urls' => urls
    }
    render json: options
  end

  def email_to_friend
    email = params[:email]
    image = params[:imgurl]
    UserMailer.image_link_to_friend(email, image).deliver
    success = "email has been sent"
    msg = {'success' => success
    }
    render json: msg
  end
  def add_favourite
    puts params[:name]
    puts params[:user_id]
    puts params[:img_url]
    fav = Favourite.create(:image_name=> params[:name],:user_id => params[:user_id], :img_url => params[:img_url])

    fav.save!
    success = "Added as favourite"
    msg = {'success' => success
    }
    render json: msg
    end
  private
# This is private method which we can call across same class level and getting api response to this

  def get_response
   puts params[:email]
    url = 'https://mdms.owenscorning.com/api/v1/product/shingles?zip=43659'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response)
  end

end