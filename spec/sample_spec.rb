require 'open3'
Dir.chdir File.join(File.dirname(__FILE__), '../')
require './spec/helpers'

#Files that are reported as bugged end up here for testing.
RSpec.describe "Live Culture" do
#  it "Can run jquery_ajax.js and output success" do
    #begin
      #@web = Webbing.get("/", 4545) do |info|
        #{"hello" => "world"}
      #end

      #begin
        #Timeout.timeout(8) do
          #IO.popen "ruby -Ilib ./bin/boojs ./spec/samples/jquery_ajax.js", "r" do |p|
            #begin
              #@res = p.readline.strip
            #ensure
              #Process.kill 9, p.pid
            #end
          #end
        #end
      #rescue
      #end

      #expect(@res).to eq("success")
    #ensure
      #Process.kill(:KILL, @web.pid)
    #end
  #end

  #it "Will output to stderr on syntax error" do
    #begin
      #begin
        #Timeout.timeout(8) do
          #IO.popen "ruby -Ilib ./bin/boojs ./spec/samples/syntax_problem.js", "r" do |p|
            #begin
              #@res = p.readline.strip
            #ensure
              #Process.kill 9, p.pid
            #end
          #end
        #end
      #rescue
      #end

      #expect(@res).to eq(nil)
    #ensure
    #end
  #end

  #it "Will output '3' when running inputting set_a_stdin.js via stdin" do
    #stim = File.open("./spec/samples/set_a_stdin.js")

    #IO.popen "ruby -Ilib ./bin/boojs", "r+" do |p|
      #loop do
        #break if stim.eof
        #p.puts stim.gets
      #end

      #res = p.readline.strip
      #expect(res).to eq("3")
    #end
  #end

  $stdout.sync = true
  it "can run another_syntax_problem.js with the correct formatting for error" do
    stim = File.open("./spec/samples/another_syntax_problem.js")

    Open3.popen3 "ruby -Ilib ./bin/boojs -v ./spec/samples/another_syntax_problem.js" do |i, o, e, t|
      begin
        i.puts stim
        read = e.read
        expect(read =~ /<-*[ ]*\w/)
      ensure
        begin
          Process.kill :INT, t[:pid]
        rescue Errno::ESRCH
        end
      end
    end
  end
end
