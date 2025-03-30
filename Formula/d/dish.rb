class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://github.com/thevxn/dish/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0238614dee2dcc70fb5d1d6a4bab2eb766335474b0835b7fbaa540d8c73a4750"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8090b66b20f175d132edfefa27c52f65a7b4a56f47e294d25f9cf65d0a5cce3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8090b66b20f175d132edfefa27c52f65a7b4a56f47e294d25f9cf65d0a5cce3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8090b66b20f175d132edfefa27c52f65a7b4a56f47e294d25f9cf65d0a5cce3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ece7754be7c6554405fa18bc6ebeaa048387ddd66534868c233e165821ca2a5"
    sha256 cellar: :any_skip_relocation, ventura:       "9ece7754be7c6554405fa18bc6ebeaa048387ddd66534868c233e165821ca2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "715ce7c2a122672f8cd05e9d09297ab2a5eeaf02ef21a1bb5eea93ad405672ea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dish"
  end

  test do
    ouput = shell_output("#{bin}/dish https://example.com/:instance 2>&1", 1)
    assert_match "error fetching sockets from remote source --- got 404 (404 Not Found)", ouput
  end
end
