class LibpostalRest < Formula
  desc "REST API for libpostal"
  homepage "https://github.com/johnlonganecker/libpostal-rest"
  url "https://github.com/johnlonganecker/libpostal-rest/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d02d738fe1d8aee034c47ff9e8123e55885fe481f1a6307fbfe286b7b755468d"
  license "MIT"

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libpostal"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "json"

    port = free_port
    ENV["LISTEN_PORT"] = port.to_s
    pid = spawn bin/"libpostal-rest"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    command = <<~EOS
      curl --silent --retry 5 --retry-connrefused -X POST -d '{"query": "100 main st buffalo ny"}' http://0.0.0.0:#{port}/parser
    EOS
    expected = [
      {
        "label" => "house_number",
        "value" => "100",
      },
      {
        "label" => "road",
        "value" => "main st",
      },
      {
        "label" => "city",
        "value" => "buffalo",
      },
      {
        "label" => "state",
        "value" => "ny",
      },
    ]

    parsed = JSON.parse shell_output(command)
    assert_equal expected, parsed
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
