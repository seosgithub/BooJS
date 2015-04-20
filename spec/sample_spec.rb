Dir.chdir File.join(File.dirname(__FILE__), '../')
#Files that are reported as bugged end up here for testing.
RSpec.describe "Live Culture" do
  it "Can run jquery_ajax.js and output success" do
    begin
      Timeout.timeout(8) do
        IO.popen "ruby -Ilib ./bin/boojs ./spec/samples/jquery_ajax.js", "r" do |p|
          begin
            @res = p.readline.strip
          ensure
            Process.kill 9, p.pid
          end
        end
      end
    rescue
    end

    expect(@res).to eq("success")
  end
end
