class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.3.4",
      revision: "b089f9ee69924882c5d14dd1a6991deb05d9d1cd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6af4590f3bcb5f5ec35a94229f74d7d6397f343604bbe4bacece9107ef05304"
    sha256 cellar: :any,                 arm64_ventura:  "6382f8b374a765caf05ea87d99f07be318e392ba35c03ede9457f85ea8e34b09"
    sha256 cellar: :any,                 arm64_monterey: "cf61b8c3711930bf97112a8876cbf45857c97427d9f33900e5d2ab8d3d91f73c"
    sha256 cellar: :any,                 sonoma:         "81813fe8c5fa89d835769da129f375b786acc0947da5571ffb78a7573323ca2c"
    sha256 cellar: :any,                 ventura:        "27ee2b7176b9966799e88a42123fee5f9fdc5ecb850b89d19dc063f765b53922"
    sha256 cellar: :any,                 monterey:       "76a64386f0e4ff20c48a4ea3ade2182ab58247f5c6118701077634cc13836b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "721b130f3f613bb95b91e502ec48cd93f9d428975199863edd04e6a09fd39d63"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost@1.85"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"monerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}/monero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
          "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
          "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
          "ponies sixteen refer enhanced maul aztec bemused basin'" \
          "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end
