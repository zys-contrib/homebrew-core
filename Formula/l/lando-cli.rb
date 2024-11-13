class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.23.5.tar.gz"
  sha256 "9a53e59a941e085c4fe10f147aa9092a0113adac5b9b17b7b30b13a61b0bd0c0"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9388fee77ca68b4c8118b3d4695526e2dbca78021d1fac4b051e5ba588a4d18c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9388fee77ca68b4c8118b3d4695526e2dbca78021d1fac4b051e5ba588a4d18c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9388fee77ca68b4c8118b3d4695526e2dbca78021d1fac4b051e5ba588a4d18c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc13005d9fcd17d9642f99994024fdab095396817d59570e84afd3207ad880b0"
    sha256 cellar: :any_skip_relocation, ventura:       "fc13005d9fcd17d9642f99994024fdab095396817d59570e84afd3207ad880b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9388fee77ca68b4c8118b3d4695526e2dbca78021d1fac4b051e5ba588a4d18c"
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
