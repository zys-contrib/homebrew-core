class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.3.1.tar.gz"
  sha256 "07722131df254910b0ff336350b87341bc0413b18a9a197543bf2c97ee634c88"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ddfbfda7eb28d5879d06afb65db1df788775a23be8a5a1b917bc0e53dc5b4b96"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin/"nerdfetch")
  end
end
