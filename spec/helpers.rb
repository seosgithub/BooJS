require 'securerandom'
require 'json'
require 'webrick'

#Duplex pipe
###################################################################################################################
class IO
  def self.duplex_pipe
    return DuplexPipe.new
  end
end

class DuplexPipe
  def initialize
    @r0, @w0 = IO.pipe
    @r1, @w1 = IO.pipe
  end

  #Choose arbitrary side, just different ones for forked processes
  def claim_low
    @r = @r0
    @w = @w1
  end



  def claim_high
    @r = @r1
    @w = @w0
  end

  def write msg
    @w.write msg
  end

  def puts msg
    @w.puts msg
  end

  def readline
    @r.readline
  end
end
###################################################################################################################

#RESTful mock
###################################################################################################################
module Webbing
  def self.get path, port=nil, &block
    Webbing.new "GET", path, port, &block
  end

  class Webbing
    attr_accessor :pid
    attr_accessor :port

    def kill
      Process.kill("KILL", @pid)
    end

    def initialize verb, path, port=nil, &block
      @verb = verb
      @path = path
      @block = block
      @port = port || rand(30000)+3000

      @pipe = IO.duplex_pipe
      @pid = fork do
        @pipe.claim_high
        @server = ::WEBrick::HTTPServer.new :Port => @port, :DocumentRoot => ".", :StartCallback => Proc.new {
          @pipe.puts("ready")
        }
        @server.mount_proc '/' do |req, res|
          @pipe.puts req.query.to_json
          res.body = @pipe.readline
          res.header["Access-Control-Allow-Origin"] = "*"
          res.header["Content-Type"] = "json/text"
        end
        @server.mount_proc '/404' do |req, res|
          res.header["Access-Control-Allow-Origin"] = "*"

          raise WEBrick::HTTPStatus::NotFound
        end
        @server.start
      end

      @pipe.claim_low
      @pipe.readline #Wait for 'ready'
      Thread.new do
        begin
          loop do
            params = JSON.parse(@pipe.readline)
            res = @block.call(params)
            @pipe.puts res.to_json
          end
        rescue => e
          $stderr.puts "Exception: #{e.inspect}"
        end
      end
    end
  end
end
###################################################################################################################
