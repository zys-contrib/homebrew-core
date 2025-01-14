class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.23.24.tar.gz"
  sha256 "490760a0f9a07773e8821578e8f8e9520d93a67828c1d9d1bb28078fff8f0e2f"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "038d84af674de18ae405fb188d624734b498a1392d267aefcbc8ab4eccd9490b"
    sha256                               arm64_sonoma:  "d8481ddf943f38def1242640e77f0c147cc4f684ed26090ffc33463d7dfa740f"
    sha256                               arm64_ventura: "4c8a13102692b0d2303124db7bf8436d74195ddee1577abb67f301693eb27ccf"
    sha256                               sonoma:        "d5b8c79f3adfd123cd9425a99c4ca74259d2320115f78b075c64740d37799124"
    sha256                               ventura:       "3a9828ab0551b5e83bc7d2a888e46df5f74eff4323f624c402771d1bff123d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29e2cc18a1b4c2691238614691cafccf1a91b15007dbaa338d29c0cf0fbc31d"
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
