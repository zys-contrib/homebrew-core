class Tsui < Formula
  desc "TUI for configuring and monitoring Tailscale"
  homepage "https://neuralink.com/tsui"
  url "https://github.com/neuralinkcorp/tsui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "1ae87ad281587efbf80ef0bf9cc0b519dd4f08465cb378e34e97230f2f3526f0"
  license "MIT"
  head "https://github.com/neuralinkcorp/tsui.git", branch: "main"

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"tsui"
    sleep 10
    input.putc "q"
    input.puts "exit"
    sleep 10
    input.close
    sleep 10

    screenlog = (testpath/"output.txt").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")

    assert_match(Regexp.union(
                   /Status:\s+(Not )?Connected/, # If Tailscale running
                   /Failed to connect to local Tailscale daemon/, # If Tailscale not running
                 ), screenlog)
  end
end
