require 'net/http'
require 'filewatcher'

class Uploader
  DESTINATION = 'http://localhost:9292/screenshot/'

  def watch
    FileWatcher.new(['*.jpg', '*.png']).watch(20) do |filename, event|
      # TODO: Get most recent file and only upload that one
      upload(normalize_filename(filename)) if event == :new
    end
  end

  private

    def normalize_filename(filename)
      filename[2..-1]
    end

    def upload(filename)
      `curl -v -F "data=@#{filename}"  #{DESTINATION + filename} -u #{ENV['USER']}:#{ENV['PASS']}`
    end
end

Uploader.new.watch
