class Urx < Formula
  desc "Extracts URLs from OSINT Archives for Security Insights"
  homepage "https://github.com/hahwul/urx"
  url "https://github.com/hahwul/urx/archive/refs/tags/0.6.0.tar.gz"
  sha256 "fc125cffadef51c7824015131d0eaf600804fa7454b4cbbbe2402fc326916801"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e7d16b6b095ddf1d791cb1b3cbd70a116ea955fd36f6f1b37e005e2eccdae7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d3ad17ff9965eae769344e6dab9a0f1e71b628bfe4d627c59e09785a3e3174"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4800fcce0692f4ee1c450570b175142bdcd7d87efd96b64c98f5d3a4495dbf6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "49f474f76454ecda641f4588ea8c0ffc4474c1c4ea0717c1a6bcb09a3b82b97c"
    sha256 cellar: :any_skip_relocation, ventura:       "f7ce9cf24c0baa4c21a193121617f84cf60de6cfdae1ccfcc5d18971a43275d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf3125d4af0355afc037a12d991b9e5fa2b37f5259a342a36bf8e3150a43ac76"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "urx #{version}", shell_output("#{bin}/urx --version")
    assert_match "https://brew.sh/", shell_output("#{bin}/urx brew.sh --providers=cc --include-sitemap")
  end
end
