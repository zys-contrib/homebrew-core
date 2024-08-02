class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/cli/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "2b930fa5c7cbe50396d147d3cf51f382e8a7312607f9dcefc04a4ad1399f4a46"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf0b3e960e6648fbafa20d63292b7fd8ac29047cc987d41de56465656b605c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf0b3e960e6648fbafa20d63292b7fd8ac29047cc987d41de56465656b605c20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf0b3e960e6648fbafa20d63292b7fd8ac29047cc987d41de56465656b605c20"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe4ed9406dafdaaddf8f1843e64b6d6798b1c200abe3ab66d43ae2b3792d29a1"
    sha256 cellar: :any_skip_relocation, ventura:        "fe4ed9406dafdaaddf8f1843e64b6d6798b1c200abe3ab66d43ae2b3792d29a1"
    sha256 cellar: :any_skip_relocation, monterey:       "fe4ed9406dafdaaddf8f1843e64b6d6798b1c200abe3ab66d43ae2b3792d29a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "646af2fd4cb091ea4a49556b220b4350f0455088b13dfc408b845a7daf3444d0"
  end

  depends_on "node@18"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}/lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}/lando config --path proxyIp")
  end
end
