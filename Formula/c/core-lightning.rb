class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v25.02/clightning-v25.02.zip"
  sha256 "d34706fc391103047f7ccbae2979a5d90022134c82e9395052a5c42db6c33d11"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "69c1ba439cf206219c154dd28f66cbf44e531bcefd726a7b7eede0197b98b3b0"
    sha256 arm64_sonoma:  "17f04a11c8743d96bf5960cd1a74ab28f8fa77c95d1ff2064f195179cb3f2288"
    sha256 arm64_ventura: "c60f604073799ff53ffbb7a8e7d0a50df9f9b95cfd9ebc352c1edfa83b9848c1"
    sha256 sonoma:        "e9ea211db180a522a8ee32fc94cdd4a3b4a38016863498afd3c99d9fd43f542b"
    sha256 ventura:       "64f72091f377bdc161bcbe576455680a20f4c2f2976d6f543e3d71cf36264141"
    sha256 x86_64_linux:  "5ba06e91b61fffb2da1d2181da8bd1921ea27dd93c382ebc2abb8817c7c01028"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python-setuptools" => :build
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
    url "https://files.pythonhosted.org/packages/5f/d9/8518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9/mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
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
