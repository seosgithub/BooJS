Dir.chdir File.join File.dirname(__FILE__), '../'
require 'open3'

#Some things need to be re-exported into the JS Interface, e.g. console.error
RSpec.describe "JS Functions" do
  it "console.error writes to stderr" do
    @err = StringIO.new
    @out = StringIO.new

    pipe = Open3.popen3("ruby -Ilib ./bin/boojs") do |i, o, e, t|
      begin
        Timeout::timeout(5) do
          i.puts "console.error('hello world')"
          loop do
            res = select [o, e], []

            if res[0].include? e
              @err.write e.readline
            end

            if res[0].include? o
              @out.write o.readline
            end
          end
        end
      rescue Timeout::Error
      rescue EOFError
      ensure
        begin
          Process.kill(:KILL, t[:pid])
        rescue Errno::ESRCH
        end
      end

      expect(@out.string.strip).to eq("")
      expect(@err.string.strip).to eq("hello world")
    end
  end

  it "console.log writes to stdout" do
    @err = StringIO.new
    @out = StringIO.new

    pipe = Open3.popen3("ruby -Ilib ./bin/boojs") do |i, o, e, t|
      begin
        Timeout::timeout(5) do
          i.puts "console.log('hello world')"
          loop do
            res = select [o, e], []

            if res[0].include? e
              @err.write e.readline
            end

            if res[0].include? o
              @out.write o.readline
            end
          end
        end
      rescue Timeout::Error
      rescue EOFError
      ensure
        begin
          Process.kill(:KILL, t[:pid])
        rescue Errno::ESRCH
        end
      end

      expect(@out.string.strip).to eq("hello world")
      expect(@err.string.strip).to eq("")
    end
  end

  it "booPing writes 'pong' to stdout" do
    @out = StringIO.new

    pipe = Open3.popen3("ruby -Ilib ./bin/boojs") do |i, o, e, t|
      begin
        Timeout::timeout(5) do
          i.puts "booPing()"
          loop do
            res = select [o], []

            if res[0].include? o
              @out.write o.readline
            end
          end
        end
      rescue Timeout::Error
      rescue EOFError
      ensure
        begin
          Process.kill(:KILL, t[:pid])
        rescue Errno::ESRCH
        end
      end

      expect(@out.string.strip).to eq("pong")
    end
  end
end
