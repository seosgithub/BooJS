require 'open3'
require 'tempfile'
require 'securerandom'

describe "CLI" do
  before(:each) do
    #Laziness
    `ps -ax | grep phantomjs | grep -v phantomjs | awk '{print $1}' | xargs kill -9`
  end

  it "Will not exit in pipe mode" do
    @finished = false
    Thread.new do
      `ruby -I./lib ./bin/boojs`
      @finished = true
    end

    sleep 5
    expect(@finished).to eq(false)
  end

  it "Replies with pong$KEY when given ping('$key')" do
    key = SecureRandom.hex
    Thread.new do
      Open3.popen3("ruby -I./lib ./bin/boojs") do |i, o, e, t|
        i.puts "__spec_ping('#{key}')"
        @back = o.gets.chomp
      end
    end

    sleep 5
    expect(@back).to eq("pong"+key)
  end

  it "Replies with pong$KEY when given ping('$key') twice" do
    keyA = SecureRandom.hex
    keyB = SecureRandom.hex

    Thread.new do
      Open3.popen3("ruby -I./lib ./bin/boojs") do |i, o, e, t|
        i.puts "__spec_ping('#{keyA}')"
        @backA = o.gets.chomp
        i.puts "__spec_ping('#{keyB}')"
        @backB = o.gets.chomp
      end
    end

    sleep 5
    expect(@backA).to eq("pong"+keyA)
    expect(@backB).to eq("pong"+keyB)
  end

  it "Emits stderr and not stdout when an error has occurred" do
    Thread.new do
      Open3.popen3("ruby -I./lib ./bin/boojs") do |i, o, e, t|
        i.puts "no_such_variable"
        @error = e.gets.chomp
        @out = o.gets.chomp
      end
    end

    sleep 5
    expect(@error.length).not_to eq(0)
    expect(@out).to eq(nil)
  end

  it "Exits with a return code of 1 with error" do
    Thread.new do
      Open3.popen3("ruby -I./lib ./bin/boojs") do |i, o, e, t|
        i.puts "no_such_variable"
        @error = e.gets.chomp
        @exit = t.value
      end
    end

    sleep 5
    expect(@exit.exitstatus).to eq(1)
  end

  it "Can be passed a file as an argument" do
    f = Tempfile.new(SecureRandom.hex)
    f.puts "console.log('hello');"
    f.close

    Thread.new do
      Open3.popen3(%{ruby -I./lib ./bin/boojs #{f.path}}) do |i, o, e, t|
        @read = o.gets.chomp
      end
    end

    sleep 5
    expect(@read).to eq("hello")
  end

  it "Can be passed a command as an argument with the -e flag for a one shot" do
    Thread.new do
      Open3.popen3(%{ruby -I./lib ./bin/boojs -e 'console.log("hello");'}) do |i, o, e, t|
        @read = o.gets.chomp
        @value = t.value
      end
    end

    sleep 5
    expect(@read).to eq("hello")
    expect(@value).not_to eq(nil)
  end

  it "Can be passed a command as an argument with the -e flag for a one shot and a file" do
    #Write to a temporary file
    function_name = SecureRandom.hex
    value = SecureRandom.hex
    jsc = %{
      function a_#{function_name}() {
        console.log("#{value}");
      }
    }
    f = Tempfile.new(SecureRandom.hex)
    f.puts jsc
    f.close

    Thread.new do
      Open3.popen3(%{ruby -I./lib ./bin/boojs -e 'a_#{function_name}()' #{f.path}}) do |i, o, e, t|
        @read = o.gets.chomp
        @value = t.value
      end
    end

    sleep 5
    expect(@read).to eq(value)
    expect(@value).not_to eq(nil)
  end
end
