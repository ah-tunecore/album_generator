require "thor"
require "album_generator"
require "album_generator/generator"

class AlbumGenerator::CLI < Thor
  desc "generate", "Generate a new album"
  def generate
    @generated = Generator.generate(song_count)

    puts "Album Title:  #{@generated.album_title}"
    puts "Artist Name:  #{@generated.artist_name}"
    puts "Artwork File: #{@generated.artwork_file}"
    puts "Songs:"
    @generated.song_names.each_with_index do |song,i|
      puts "#{i}: #{song}"
    end
  end
end
