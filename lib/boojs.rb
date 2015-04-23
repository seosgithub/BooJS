require 'tempfile'
require 'securerandom'
require 'greenletters'
require "net/http"
require "uri"
require "open3"
require 'therubyracer'

module BooJS
  def self.verify str
    #Create tmp file
    tmp = Tempfile.new(SecureRandom.hex)
    path = tmp.path
    tmp.close!
    File.open path, "w" do |f|
      f.puts %{
        phantom.onError = function(msg, trace) {
          console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          console.log("PhantomJS Error");
          console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          console.log(msg);
          trace.forEach(function(t) {
            console.log(t.file + ': line ' + t.line );
          })
          console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          phantom.exit(1);
        }
      }
      f.puts str
      f.puts "phantom.exit(0)"
    end

    begin
      #Do we have a syntax error?
      @syntax_error = false
      Timeout.timeout(8) do
        Open3.popen3 "#{$phantomjs_path} #{path}" do |_, out, err, _|
          begin
            loop do
              rr, ww = select([out, err], []); e = rr[0]

              #PhantomJS wrote to stderr
              r = e.readline
              if r =~ /SyntaxError/
                @syntax_error = true
                raise "syntax_error" #Break out
              end
            end
          ensure
            Process.kill 9, p.pid
          end
        end
      end
    rescue => e
    end

    #PhantomJS does not support syntax checking, so we use V8 to do that
    exit 0 unless @syntax_error
    begin
      ctx = V8::Context.new
      ctx.load path
    rescue V8::Error => e
      matches = e.message.match(/.*? at (?<path>.*?):(?<line>.*?):.*?$/)
      dump_lines matches[:path], matches[:line].to_i, 10
    end

    exit 1
  end

  #Optionally, accept code to inject and a command to run
  #If the command is nil, this is not executed as a oneshot
  def self.pipe(str=nil, cmd=nil, will_timeout=false)
    js = %{
      var system = require('system');
      function __spec_ping(str) {
        system.stdout.writeLine("pong"+str)
      }

      phantom.onError = function(msg, trace) {
        system.stderr.writeLine("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        system.stderr.writeLine("PhantomJS Error");
        system.stderr.writeLine("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        system.stderr.writeLine(msg);
        trace.forEach(function(t) {
          system.stderr.writeLine(t.file + ': line ' + t.line );
        })
        system.stderr.writeLine("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        phantom.exit(1);
      }
    }
    
    #Any code the user wanted
    js += "\n#{str}" if str

    #Repl
    if cmd
      js += "\n#{cmd}"

      js += "\nphantom.exit(1)" unless will_timeout
    else
      #You can not use $stdin here, PhantomJS blocks on readLine
      js += PhantomAsyncInput.code
      #js += "\nwhile (true) { var line = system.stdin.readLine(); eval(line); }"
    end

    #Create file to load
    tmp = Tempfile.new(SecureRandom.hex)
    tmp.puts js
    tmp.close

    @input_sender_r, @input_sender_w = IO.pipe
    
    #Phantom JS Process
    p = IO.popen("#{$phantomjs_path} #{tmp.path}")
    loop do
      rr, _ = select([p, STDIN]); e = rr[0]
      #PhantomJS has written something
      if e == p
        res = e.readline

        if res =~ /STDIN_PORT/
          port = res.split(" ")[1].to_i
          start_server(port, @input_sender_r)
        else
          puts res
          $stdout.flush
        end
      end

      #User has written to this program
      if e == STDIN
        @input_sender_w.puts e.readline
      end
    end

    tmp.unlink
    exit ret
  rescue EOFError => e
    exit 1
  end

  def self.start_server port, pipe
    #Server that manages inputs
    Thread.new do
      begin
        loop do
          rr, __ = IO.select([@input_sender_r], []); e = rr[0]

          uri = URI.parse("http://localhost:#{port}")
          Net::HTTP.post_form(uri, {:str => e.readline})
        end
      rescue Exception => e
        $stderr.puts "Input server exception: #{e.inspect}"
      end
    end
  end

  #Show the lines of somethingl ike a source file will 
  #show around center_num where it has n_expand lines around
  #the center_num.  If you pass msg, it will output the 
  #information next to the arrow
  #  -----------------------------------------------
  #  my_source.js
  #  -----------------------------------------------
  #  2| pretend_to_do_something();
  #  3| console.log("hello world");
  #  4| console.log("hello world again"]; <-------- [optional msg]
  #  5| var x = 4;
  #  6| var y = 3;
  #  -----------------------------------------------
  def self.dump_lines fn, center_num, n_expand, msg=nil
    f = File.open(fn)
    range = (center_num-n_expand)..(center_num+n_expand)
  
    $stderr.puts "------------------------------------------------------------"
    $stderr.puts "#{File.basename(fn)}:#{center_num}"
    $stderr.puts "------------------------------------------------------------"
    f.each_line.with_index do |line, index|
      line.strip!
      if range.include? index
        if index == center_num
          $stderr.puts "#{index}| #{line} <------ " + (msg ? "[#{msg}]" : "")
        else
          $stderr.puts "#{index}| #{line}"
        end
      end
    end
    $stderr.puts "------------------------------------------------------------"
  end 
end

#You can not use stdin readLine from PhantomJS because it blocks. This is a workaround where
#commands are queued via the built-in server and then evaluated asynchronously via setInterval.
#This method is used because exceptions that occur inside the calling context of the server response
#cause the server to crash without notifying the application via phantom.onError
module PhantomAsyncInput
  def self.code
    %{
      __async_stdin_queue = []
      __webserver = require('webserver');
      __server = __webserver.create();
      __port = Math.floor((Math.random() * 3000) + 3000); 
      console.log("STDIN_PORT " + __port)
      __service = __server.listen(__port, function(req, res) {
        //Reply
        var str = req.post.str
        __async_stdin_queue.unshift(str)
        res.write("ok");
        res.close();
      });

      function __async_stdin_dequeue() {
        //Nothing to process
        if (__async_stdin_queue.length == 0) {
            return;
        }

        var str = __async_stdin_queue.pop()
        eval(str);
      }
      setInterval(__async_stdin_dequeue, 50);
    }
  end
end
