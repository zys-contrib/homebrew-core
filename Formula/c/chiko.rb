class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "054151d8c8c05ff2ccf0283328221b8143ea17146ef4dde4d63d7f1d31b11748"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd41383d3f47e13a627ff206c0d872c0f9f9c370d35b11c1df23d47ce0bc9a01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd41383d3f47e13a627ff206c0d872c0f9f9c370d35b11c1df23d47ce0bc9a01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd41383d3f47e13a627ff206c0d872c0f9f9c370d35b11c1df23d47ce0bc9a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "95f3adb6387216e35e0a08c60849da2cf505d272d722a945552e828938223a1f"
    sha256 cellar: :any_skip_relocation, ventura:       "95f3adb6387216e35e0a08c60849da2cf505d272d722a945552e828938223a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d16ef868de58aa16621430bfe95de26dd79a3fd38396e2c83d374820fc181e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08c09d30f7c1d79a484bdfc1a4d97f36cb85ac0022a167af63055b49463bbcf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/chiko"
  end

  test do
    ENV["TERM"] = "xterm"
    require "pty"

    PTY.spawn(bin/"chiko") do |r, w, _pid|
      w.write "q"
      assert_match "The Ultimate Beauty GRPC Client", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
