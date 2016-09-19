require "thor"
require "album_generator"
require "album_generator/generator"

class AlbumGenerator::CLI < Thor
  desc "generate", "Generate a new album"
  def generate
    @generated = Generator.generate

    puts "Artist Name:  #{@generated.artist_name}"
    puts "Album Title:  #{@generated.album_title}"
    puts "Artwork File: #{@generated.artwork_file}"
  end
end
