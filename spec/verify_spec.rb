require 'tempfile'

RSpec.describe "Load Verification" do
  it "Returns 1 when the syntax is invalid" do
    file = Tempfile.new(SecureRandom.hex)
    file.puts "gibberish"
    file.close

    p = IO.popen("ruby -Ilib ./bin/boojs -v #{file.path}")

    expect(p.readline).to equal("")
  end
end
