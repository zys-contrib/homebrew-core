class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v21.5.3.tar.gz"
  sha256 "a30c7b5291558a0924d79924f6add2b5db0514ff67dabd71f5ecbb12a957d928"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1cb38a6c9e5a6052c773c4c4520defdba860676d7fdc833e9e24f400265ca49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd48c97e3a519d65d0b5b8e09a30876df3bbf4de8e23596658b70190c0be109a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5b0a8d7d86b8f6138c1daedd9b7dd0dbf6f57b10696f28992ec7feb1718cbb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "826d3d7c862b62865eeeb859d5f29aec7303e0e47f0a6cdde3febdf4c1dd459d"
    sha256 cellar: :any_skip_relocation, ventura:       "8d35c0f5a319f7b39e5d6151679089cfaec795d0315b4fac44c14dee2a86f04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0381d80cd30b9192fc312270e3b2ced7cf135e1ac4ad4985e35fed5493d20f75"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
