class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://github.com/thevxn/dish/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "a7091d6e42706d172ffb8e6791474626b9164460d2cad60baadbf6c26cd3720e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f49f65354be10a35fa8361bd96f06be900b32114ce4734bfaab5d30b4e69c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f49f65354be10a35fa8361bd96f06be900b32114ce4734bfaab5d30b4e69c5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f49f65354be10a35fa8361bd96f06be900b32114ce4734bfaab5d30b4e69c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "405ca2aa41c254e8e3d1d7c15f5887eed9b4105c3a46ca45061f4e09015e8ca9"
    sha256 cellar: :any_skip_relocation, ventura:       "405ca2aa41c254e8e3d1d7c15f5887eed9b4105c3a46ca45061f4e09015e8ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b58ac6a2e266466bdb6a47dbf86ba719ec3564b650dd5604e98662c86d33c0"
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
