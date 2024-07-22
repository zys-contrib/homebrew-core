class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.4.2.tar.gz"
  sha256 "3c14cbf499f1f260a08593a38ee6bce692bc322dbbe5441e41f3e4a7c9e811b3"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6f58178c3f0121bf2a0491ad8fec13a73185052e8d23686613874e28d36552e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "593562012797f414832ae1982c80afc7664b8a1ec9c9cc919fabe5cff4d7704d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9981db992e4578159f0614df97f1496266e9d326e2edf287c8a6cbc4d4b0068c"
    sha256 cellar: :any_skip_relocation, sonoma:         "577f2ea0675a1a4b012f65083f3818ac368de3af1d828f18d5d89882c69ca8b3"
    sha256 cellar: :any_skip_relocation, ventura:        "6dda5ea2e8d089fb81f40ef17133a4dc1e4fa6d7b8aac5603e9a65f1ef4051e8"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a3f55d4de94f44b9b576a31a3589c80130b12b3f0eb19b1f546d4bce13dbc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd48a5cc191e48fc6ed3ff318cf1f24d724128a51ef4194bb4e8888ade70de6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath/"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end
