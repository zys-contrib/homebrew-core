class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "2a7b774b01522587601db1c45e785ee9304ccd52c86389a728bc6e94db910e83"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b2922f7f2ca8960b55a295009bde2ef6568caaf819ba99f3c51ee7e32e7093f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d911de273c0fbb1be68dc9db765a92e6cb1b98accbd53110ff22e5d575e8ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2433f113c2c7614ec9d70d340b7ee083eb5a2da32a370c8223b7ac9c3c73349"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d379bc544d54758ec5ff8f904850890f3bd779a1e5c2f9e76b235f3fc7205a0"
    sha256 cellar: :any_skip_relocation, ventura:        "63d02dcad9619a3c8fed3bbee127d1eb44baece9eb33b2f884f0a87902f5c68b"
    sha256 cellar: :any_skip_relocation, monterey:       "0982663caa98e50d7936464c7e290ff02e56befde598f839ab3f55543098dfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7018f1c80018a0e80d62288a11d15abdc46dd0ae1a49c096ed7aad9c02ec663c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
