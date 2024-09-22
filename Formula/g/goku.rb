class Goku < Formula
  desc "HTTP load testing tool"
  homepage "https://github.com/jcaromiq/goku"
  url "https://github.com/jcaromiq/goku/archive/refs/tags/1.1.6.tar.gz"
  sha256 "c98e99975942d52932bb1b141aa19390183594793ac38c9db7b1871b06bd24c7"
  license "MIT"
  head "https://github.com/jcaromiq/goku.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/goku --target https://httpbin.org/get")
    assert_match "kamehameha to https://httpbin.org/get with 1 concurrent clients and 1 total iterations", output

    assert_match version.to_s, shell_output("#{bin}/goku --version")
  end
end
