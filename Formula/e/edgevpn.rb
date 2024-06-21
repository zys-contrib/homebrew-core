class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "cbd0fa9a1dd496d5a941470ad22619d4338b20965aff8f4c1625562386d6b564"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "484094e622282432bfde9d57480a7895ce16a4d366878423a9d751a2a9d4a73f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "484094e622282432bfde9d57480a7895ce16a4d366878423a9d751a2a9d4a73f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484094e622282432bfde9d57480a7895ce16a4d366878423a9d751a2a9d4a73f"
    sha256 cellar: :any_skip_relocation, sonoma:         "03fc4bba3119ff5b88f2f6b1381c5a939d6137663a3a5e4c719793bc2bb29751"
    sha256 cellar: :any_skip_relocation, ventura:        "03fc4bba3119ff5b88f2f6b1381c5a939d6137663a3a5e4c719793bc2bb29751"
    sha256 cellar: :any_skip_relocation, monterey:       "03fc4bba3119ff5b88f2f6b1381c5a939d6137663a3a5e4c719793bc2bb29751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3ac237988b39f59a6e17daa4e00ba3afaad7f4691b9c4bca6fa6cc15dc90a4f"
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
