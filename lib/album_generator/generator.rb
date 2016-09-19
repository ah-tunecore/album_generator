require 'nokogiri'
require 'pry'
require 'open-uri'
require 'mini_magick'

class Generator
  class GeneratorException < StandardError; end

  def self.generate
    generated = new
    generated.generate

    generated
  end

  @@title_retry_limit   = 5
  @@name_retry_limit    = 5
  @@artwork_retry_limit = 5

  def initialize
    @title_retry   = 0
    @name_retry    = 0
    @artwork_retry = 0
  end

  def generate
    get_album_title
    get_artist_name
    get_album_artwork
  end

  attr_reader :album_title, :artist_name, :artwork_file

  private

  def get_album_title
    html = fetch_url("http://www.quotationspage.com/random.php3")
    quote = html.css(".quote").last.text.split("\s")

    @album_title = quote[(quote.length - 5)..-1].map(&:capitalize).join(" ")
  rescue
    handle_exception(@title_retry += 1, @@title_retry_limit, :get_album_title)
  end

  def get_artist_name
    html = fetch_url("https://en.wikipedia.org/wiki/Special:Random")

    @artist_name = html.css("#firstHeading").last.text
  rescue
    handle_exception(@name_retry += 1, @@name_retry_limit, :get_artist_name)
  end

  def get_album_artwork
    html        = fetch_url("https://www.flickr.com/explore/interesting/7days")
    user_url    = "https://www.flickr.com" + html.css(".Photo")[2].children.xpath("a").last.values[1] + "sizes/o"
    html2       = fetch_url(user_url)
    artwork_url = html2.css("#allsizes-photo").last.children.css("img").attribute("src").value
    image       = MiniMagick::Image.open(artwork_url)
    image.crop "1600x1600"
    @artwork_file = "artwork.jpg"

    image.write(artwork_file)
  rescue
    handle_exception(@artwork_retry += 1, @@artwork_retry_limit, :get_album_artwork)
  end

  private

  def fetch_url(url)
    Nokogiri::HTML(open(url))
  end

  def handle_exception(retry_count, retry_limit, callback)
    if retry_count > retry_limit
      raise GeneratorException.new "unable to perform #{callback}"
    else
      send(callback)
    end
  end
end

