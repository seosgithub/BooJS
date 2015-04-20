require 'tempfile'
require 'securerandom'
require 'greenletters'

module BooJS
  def self.verify str
    phantom = Phantomjs.path

    #Create tmp file
    tmp = Tempfile.new(SecureRandom.hex)
    tmp.puts %{
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
    tmp.puts str
    tmp.puts "phantom.exit(0)"
    tmp.close

    system("phantomjs #{tmp.path} 2>&1") or raise "Verifying failed"
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
      js += "\nwhile (true) { var line = system.stdin.readLine(); eval(line); }"
    end

    tmp = Tempfile.new(SecureRandom.hex)
    tmp.puts js
    tmp.close
    ret = system("#{$phantomjs_path} #{tmp.path}")

    tmp.unlink
    exit ret
  end
end
