class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "f3969c152c0fe99a2a90e8c8675ab677d77608ac77c957a95497387c36363c32"
  license "GPL-2.0-only"
  head "https://github.com/drwetter/testssl.sh.git", branch: "3.2"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "98472bbc6189b852365f0a100a38deaa91404d700ae89642ac9c40a1f1d258b3"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "bind" => :test # can also use `drill` or `ldns`
    depends_on "util-linux" # for `hexdump`
  end

  def install
    bin.install "testssl.sh"
    man1.install "doc/testssl.1"
    prefix.install "etc"
    env = {
      PATH:                "#{Formula["openssl@3"].opt_bin}:$PATH",
      TESTSSL_INSTALL_DIR: prefix,
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"testssl.sh", "--local", "--warnings", "off"
  end
end
