class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "13fe5870b0e2cbbb47c8ee876ef8383bebe92460cfc001fc6b076833bb58b210"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5de3e68f49a59a40e423fbf10f8139e01342822ce70827b202ee4b0fccc4e019"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5de3e68f49a59a40e423fbf10f8139e01342822ce70827b202ee4b0fccc4e019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de3e68f49a59a40e423fbf10f8139e01342822ce70827b202ee4b0fccc4e019"
    sha256 cellar: :any_skip_relocation, sonoma:         "d65ebca8a1ff98c265dce3afbf23cd97d834195ade22b236f002b9471ebfa9b0"
    sha256 cellar: :any_skip_relocation, ventura:        "d65ebca8a1ff98c265dce3afbf23cd97d834195ade22b236f002b9471ebfa9b0"
    sha256 cellar: :any_skip_relocation, monterey:       "d65ebca8a1ff98c265dce3afbf23cd97d834195ade22b236f002b9471ebfa9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0df9804defd6cc7e495fff392197d4431a77eb8ac432940890a52150e41480e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mudler/edgevpn/internal.Version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end
