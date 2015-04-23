require 'tempfile'

RSpec.describe "Load Verification" do
  it "Returns 1 when the syntax is invalid" do
    file = Tempfile.new(SecureRandom.hex)
    file.puts "function ()"
    file.close

    system("ruby -Ilib ./bin/boojs -v #{file.path}")

    expect($?.exitstatus).to equal(1)
  end

  it "Returns 0 when the syntax is valid" do
    file = Tempfile.new(SecureRandom.hex)
    file.puts "function test() {}"
    file.close

    system("ruby -Ilib ./bin/boojs -v #{file.path}")

    expect($?.exitstatus).to equal(0)
  end
end
