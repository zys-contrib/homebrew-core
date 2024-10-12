class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "ed575807b0490411670556d4471338f418c326bb1ffe25f52977735012851765"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a43b59645171e6045806d8f492cd8c9fb6566785478cbb43c036308b08a50514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a27e7e6720095678916b47236b60ba280773f57d3168450c73a81b8857c8815c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a27e7e6720095678916b47236b60ba280773f57d3168450c73a81b8857c8815c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27e7e6720095678916b47236b60ba280773f57d3168450c73a81b8857c8815c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7a3db5ee313e576ab5b8ec6b3353153e0161c33396ed8355a49a094908fd5e1"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a3db5ee313e576ab5b8ec6b3353153e0161c33396ed8355a49a094908fd5e1"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a3db5ee313e576ab5b8ec6b3353153e0161c33396ed8355a49a094908fd5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbbcfddd4e05137303c86f5d25bbbf8ecccd093a72c6af80cd79b800bdf5d4b"
  end

  depends_on "go@1.22" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match %r{Proxy-Agent: gost/#{version}}i, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
