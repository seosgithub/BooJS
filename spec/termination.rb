#Verify correct termination (full cleanup on any exit)
require 'open3'
require 'tempfile'
require 'securerandom'

BOOJS = File.join(File.dirname(__FILE__), "../bin/boojs")

describe "CLI" do
  before(:each) do
    #Laziness
  end

  it "Will output a pid for the first stdout when given the -p flag via the command line" do
    begin
      p = IO.popen("#{BOOJS} -p", "r+")

      Timeout.timeout(6) do
        @line = p.readline
      end

      expect(@line).to match(/\d*/)
    ensure
      Process.kill(:INT, p.pid)
    end
  end

  it "Will terminate the process it spawns after the main program is sent a SIGINT" do
    begin
      p = IO.popen("#{BOOJS} -p", "r+")

      Timeout.timeout(6) do
        @spawned_pid = p.readline.to_i
      end

      #Kill boojs process
      Process.kill :INT, p.pid

      sleep 1

      #Make sure phantomJS process is not running
      begin
        res = Process.kill 0, @spawned_pid
      rescue Errno::ESRCH
        @phantomjs_did_not_exist = true
      end

      expect(@phantomjs_did_not_exist).to eq(true)
    ensure
      begin
        #Process.kill(:INT, p.pid)
        #Process.kill(:INT, @spawned_pid)
      rescue Errno::ESRCH
      end
    end
  end

  it "Will terminate the process it spawns after the main program is sent a SIGTERM" do
    begin
      p = IO.popen("#{BOOJS} -p", "r+")

      Timeout.timeout(6) do
        @spawned_pid = p.readline.to_i
      end

      #Kill boojs process
      Process.kill :TERM, p.pid

      sleep 1

      #Make sure phantomJS process is not running
      begin
        res = Process.kill 0, @spawned_pid
      rescue Errno::ESRCH
        @phantomjs_did_not_exist = true
      end

      expect(@phantomjs_did_not_exist).to eq(true)
    ensure
      begin
        Process.kill(:INT, p.pid)
        Process.kill(:INT, @spawned_pid)
      rescue Errno::ESRCH
      end
    end
  end
end
