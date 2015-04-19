require 'tempfile'
require 'securerandom'

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
end
