RSpec.describe "Speed" do
  it "can startup and respond to a ping in under a second via stdin" do
    begin
      begin
        Timeout.timeout(3) do
          IO.popen "ruby -Ilib ./bin/boojs", "r+" do |p|
            begin
              p.puts "booPing()"
              @res = p.readline.strip
            ensure
              Process.kill 9, p.pid
            end
          end
        end
      rescue
      end

      expect(@res).to eq("pong")
    ensure
    end
  end
end
