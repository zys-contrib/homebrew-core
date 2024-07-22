class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "4f3063c4c31f0cb95fc50af5e418149eef6829fc92314031f3f69d5eb2a4a77c"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b7f835fa0d1a49c346c49285bdba6d75c79ecce135415a980e12010ad39aa767"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output("#{bin}/nerdfetch")
  end
end
