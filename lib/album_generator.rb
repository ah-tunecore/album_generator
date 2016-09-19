require "album_generator/version"
require "album_generator/generator"
require "album_generator/cli"

module AlbumGenerator
  class Base
    def self.start
      AlbumGenerator::CLI.start
    end
  end
end
