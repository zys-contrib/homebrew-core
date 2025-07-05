class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate/archive/refs/tags/1.0.8.tar.gz"
  sha256 "fc5ce220b0ddb37ba05af9c5aa498c27163469fb9dbd3a962bf693417d033f6a"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "json"

    port = free_port
    args = %W[
      server
      -p #{port}
    ]
    preset = JSON.generate({
      name:        "Test Preset",
      command:     "blah",
      description: "fake it",
      outputFile:  "test.mp4",
    })
    api = "http://localhost:#{port}/api/v1"
    pid = spawn(bin/"ffmate", *args)
    begin
      sleep 2
      assert_match version.to_s, shell_output("curl -s #{api}/version")
      assert_match "uuid", shell_output("curl -s -X POST #{api}/presets -d '#{preset}'")
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
    ensure
      Process.kill "TERM", pid
    end
  end
end
