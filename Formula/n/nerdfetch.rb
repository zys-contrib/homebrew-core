class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.2.1.tar.gz"
  sha256 "e35d661099f31d06180d110d70c9f2b0660f14b941e77f36cae3304ab7c724a3"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0eb25ab4dcbba8cc49be7b1bd3197bb5328d8dde061512e148b5ad38ee4b26b"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output("#{bin}/nerdfetch")
  end
end
