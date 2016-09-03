require 'nokogiri'
require 'pry'
require 'open-uri'
require 'mini_magick'

class Generator
  def self.generate
    generated = new
    generated.generate

    generated
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
    puts "error generating album text"
  end

  def get_artist_name
    html = fetch_url("http://en.wikipedia.org/wiki/Special:Random")

    @artist_name = html.css("#firstHeading").last.text
  rescue
    puts "error generating artist name"
  end

  def get_album_artwork
    html = fetch_url("https://www.flickr.com/explore/interesting/7days")
    user_url = "https://www.flickr.com" + html.css(".Photo")[2].children.xpath("a").last.values[1] + "sizes/o"
    html2 = fetch_url(user_url)
    artwork_url = html2.css("#allsizes-photo").last.children.css("img").attribute("src").value
    image = MiniMagick::Image.open(artwork_url)
    image.crop "1600x1600"
    @artwork_file = "artwork.jpg"
    image.write(artwork_file)

  end

  def fetch_url(url)
    Nokogiri::HTML(open(url))
  end
end
