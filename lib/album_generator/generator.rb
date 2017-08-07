require 'nokogiri'
require 'open-uri'
require 'mini_magick'

class Generator
  class GeneratorException < StandardError; end

  def self.generate(song_count = 5)
    new(song_count).tap(&:generate)
  end

  @@title_retry_limit   = 10
  @@name_retry_limit    = 10
  @@artwork_retry_limit = 10

  def initialize(song_count)
    @title_retry   = 0
    @name_retry    = 0
    @artwork_retry = 0
    @song_retry    = 0
    @song_count    = song_count
    @song_names    = []
  end

  def generate
    get_album_title
    get_artist_name
    get_album_artwork
    get_song_names
  end

  attr_reader :album_title, :artist_name, :artwork_file, :song_names

  private

  def random_quote
    html = fetch_url("http://www.quotationspage.com/random.php3")
    q = html.css(".quote").last.text.split("\s")
    q[(q.length - 5)..-1].map(&:capitalize).join(" ")
  end

  def get_album_title
    @album_title = random_quote
  rescue => e
    handle_exception(e, @title_retry += 1, @@title_retry_limit, :get_album_title)
  end

  def get_song_names
    (1..@song_count).each {|i| @song_names << random_quote }
  end

  def get_artist_name
    html = fetch_url("https://en.wikipedia.org/wiki/Special:Random")

    @artist_name = html.css("#firstHeading").last.text
  rescue => e
    handle_exception(e, @name_retry += 1, @@name_retry_limit, :get_artist_name)
  end

  def get_album_artwork
    html        = fetch_url("https://www.flickr.com/explore/interesting/7days")
    user_url    = "https://www.flickr.com" + html.css(".Photo")[2].children.xpath("a").last.values[1] + "sizes/o"
    html2       = fetch_url(user_url)
    artwork_url = html2.css("#allsizes-photo").last.children.css("img").attribute("src").value
    image       = MiniMagick::Image.open(artwork_url)
    image.combine_options do |b|
      b.resize "1600x1600!"
    end
    @artwork_file = "/tmp/artwork.jpg"
    image.write(artwork_file)
  rescue => e
    handle_exception(e, @artwork_retry += 1, @@artwork_retry_limit, :get_album_artwork)
  end

  private

  def fetch_url(url)
    Nokogiri::HTML(open(url))
  end

  def handle_exception(error, retry_count, retry_limit, callback)
    if retry_count > retry_limit
      raise GeneratorException.new "unable to perform #{callback}: #{error.message}"
    else
      send(callback)
    end
  end
end

