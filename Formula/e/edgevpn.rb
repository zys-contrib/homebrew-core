class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "13fe5870b0e2cbbb47c8ee876ef8383bebe92460cfc001fc6b076833bb58b210"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1b76199138397340487684440b1353b82641ad5a813b9f223cc60a31958938a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1b76199138397340487684440b1353b82641ad5a813b9f223cc60a31958938a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b76199138397340487684440b1353b82641ad5a813b9f223cc60a31958938a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba275e3d1b42b8c885430bd90091820a6964c795f59d1f46b7ccbfd8665e7d6e"
    sha256 cellar: :any_skip_relocation, ventura:        "ba275e3d1b42b8c885430bd90091820a6964c795f59d1f46b7ccbfd8665e7d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "ba275e3d1b42b8c885430bd90091820a6964c795f59d1f46b7ccbfd8665e7d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d7a495e8d7d0352e7361f2651be854ca5b1aa396d6a4123a71644aebc4e44e6"
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
