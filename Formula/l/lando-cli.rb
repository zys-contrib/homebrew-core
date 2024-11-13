class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.23.6.tar.gz"
  sha256 "d3c239d8a6379bcd982b807e0f7910ca78eb8644917897ba395cbc307b39af2e"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "0dbcf9e209b7ebad0eb3ad9b061d4c525e2ef520a2c2b728175f46fdedd8a64b"
    sha256                               arm64_sonoma:  "db15870b7b8c9a541e784d478acb80a883c1211d5e2553d944d25604aeea066a"
    sha256                               arm64_ventura: "069996fb0e3c1d88bfa8c084603025c352f324e18323a63df895d3298f7d13a0"
    sha256                               sonoma:        "6ce35e22a8786ef30b79b03b4bb3cd93f8c14efd0ac57154c3cb63230b8fda67"
    sha256                               ventura:       "d0800014c5a9b8bff9a77c5b33e2a905e5e714c09f3914873e571de7792f55e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab2ede39220c855c870a34e80d9cb5ad290880d125bf63058bae9cf409bdbbfa"
  end

  depends_on "node"

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
