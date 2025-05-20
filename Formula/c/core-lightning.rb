class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v25.02.2/clightning-v25.02.2.zip"
  sha256 "db0a7da35a5a58959fc48be6f410e7b0a5f718351729a3e4a41f3d7306fa3a3f"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "b49f2814b9ec4357c2ab5db5efbe0b1eba2a109f99aa74ce3b17cec19b03f016"
    sha256 arm64_sonoma:  "79be98d83c0aac8cd5d489930b4794d1f83659c5e8d1175ba9f5b41ae17e5f98"
    sha256 arm64_ventura: "bf0160cd78e908de4cf9a1effb96281523a3a6f9fbddf6ef5a92577d7b86508d"
    sha256 sonoma:        "f79a9e56ff37376cce4f46ef30f51365322529d9f51b999fef77a35288ff9183"
    sha256 ventura:       "c3de74f46974d05b446abcdd9121bd5df1fb684ec608821c7a3bd75a6e23b9c9"
    sha256 arm64_linux:   "75bdf892a9e16bd2de28c37f741aba769a787f6d0c2b9392698697be1ea178d3"
    sha256 x86_64_linux:  "6a24472f3b1f8ebd6b1d4f678ca8b6abc63b9a44dda8c1ae43252585e1bf813a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.13" => :build
  depends_on "rust" => :build
  depends_on "bitcoin"
  depends_on "libsodium"

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "python", since: :catalina
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  # Configure script overwrites `PKG_CONFIG_PATH` on macOS
  # PR: https://github.com/ElementsProject/lightning/pull/8146
  patch do
    url "https://github.com/botantony/lightning/commit/cca721a9f3c5a15f6792b0dc1941959dbd93ac2f.patch?full_index=1"
    sha256 "ee375b92de3d49f4bdf33acf2eb672b693f5806ee418a380e37f3a6a4047c91d"
  end

  def install
    rm_r(["external/libsodium", "external/lowdown"])

    venv = virtualenv_create(buildpath/"venv", "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
