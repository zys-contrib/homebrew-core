class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  stable do
    url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.4.0.tar.gz"
    sha256 "8164f52beb3a1f94b2eb9a20ca9dae495378bc87ca061c9654fb349f10d02a28"

    # version patch
    patch do
      url "https://github.com/stellar/stellar-cli/commit/e629c6255edb8ce94ab181fd906469cb33631c80.patch?full_index=1"
      sha256 "9da8629065530143e9e9583565a96c3f204bbb884992604a97a06cdd40ceb5b1"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc440feec95560befc6f897ad9d35c7c94c33951cad66c38bf66fff3d30c73be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2744c25f71ee2cd483954a89b3fa92867ac8cf2c2ce7b198d5737fbf810a7ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "084c413de377523beb81ec084760e45990d55ec8561738b84fb421eb1042cf73"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ea755df0a760f0f03658344ce88b47339950b0cc47ebbcbd0ac481a684112c"
    sha256 cellar: :any_skip_relocation, ventura:       "78de1f3155f28a8f3e3a8261e8e1c7c04aeb6c0952f3c5e853083c7617242efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14e98a0fb5131b95e3c0b3214afefdeffd120ff35fe6dedc78de3bb014c5eda"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
