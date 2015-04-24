RSpec.describe "ping" do
  it "writes pong" do
    begin
      begin
        Timeout.timeout(8) do
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
