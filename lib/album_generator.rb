require "album_generator/version"
require "album_generator/generator"

module AlbumGenerator::CLI < Thor

  desc "generate", "will output random album details"
  def generate
    @generated = Generator.generate

    puts "Artist Name:  #{@generated.artist_name}"
    puts "Album Title:  #{@generated.album_title}"
    puts "Artwork File: #{@generated.artwork_file}"
  end
end
