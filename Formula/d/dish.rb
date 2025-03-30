class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://github.com/thevxn/dish/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0238614dee2dcc70fb5d1d6a4bab2eb766335474b0835b7fbaa540d8c73a4750"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dish"
  end

  test do
    ouput = shell_output("#{bin}/dish https://example.com/:instance 2>&1", 1)
    assert_match "error fetching sockets from remote source --- got 404 (404 Not Found)", ouput
  end
end
