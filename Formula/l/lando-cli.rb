class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.23.7.tar.gz"
  sha256 "baa02fe1733c6d76a6ba42c058dba9b308e1246378994b7441d18b5833815d8c"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "7dc9a19e5deef5bcf4a8b6d4f6c4d629de3dc129409bb5bebdfd024bdc11a6e6"
    sha256                               arm64_sonoma:  "c8d639964dfb5460bc464fcfebb809b6edaebb1e695156d4d2e11879c5ef9a05"
    sha256                               arm64_ventura: "0356a8fe9e4c3a8c62ffca21093bd855c0ce1669837850c7e18e6932f313ae24"
    sha256                               sonoma:        "1d7030c5ccb046aca8f946ed5da210d9886bdae891b92e783c1287f5c2c2e076"
    sha256                               ventura:       "5794a6389ca8083b3c0c39567afefa1bd4684ec80730c5bb8e5e5b99e473d1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa9dc14244d7b257665d1d66407576385fa0cc1aa8b74a8302a95ef82efc296"
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
