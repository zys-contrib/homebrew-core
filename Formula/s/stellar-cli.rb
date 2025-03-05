class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.3.0.tar.gz"
  sha256 "99366c26e0a142a82a68897710001b0190c680aad5bc4e7f396ab4c14d3948c7"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6989f6eabaeae249e88bbd25c0a8067e9af9a86cfc3fc49ec4b29f2d5b2a42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82e2d151869728d9e926a24b264e907f4b4b1d4809c940bdd220736ac7963a6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92dc936950cadcea49f27ce03cb4471eb0e3ce74be22a8c4c7acda1a8dd3a687"
    sha256 cellar: :any_skip_relocation, sonoma:        "e387c6ad7f716081c4f0e843c818ce7e216b3c8ef2550b825686762fd419146a"
    sha256 cellar: :any_skip_relocation, ventura:       "5e0dec872a5489581b2cf5046683ef81a2b2717cca7c58d9c4daadc94a731570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2cdff8788ce8cc5931015a74dc461878240ccf38e9d550369bc4a60f132098"
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
