require 'filewatcher'
require 'dotenv'
Dotenv.load

class Uploader

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
      `curl -v -F "data=@#{filename}"  #{ENV['DESTINATION'] + filename} -u #{ENV['LOGIN']}:#{ENV['PASS']}`
    end
end

Uploader.new.watch
