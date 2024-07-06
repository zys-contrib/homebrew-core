class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "56da9d55d3b09ef4ababafaf678aad018b2d3d8b3001d888fd6aafe04b33aab5"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5d3917572fb956ea8928bb9283bc70c4b31ec8e1560c3b9d6763f2d8d92e47a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60fcca4118ab45a23478872122bb715c1560b1ce728be3922c2d287a9a4e5301"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b3002cb3947125d16b1c8858f5a2e542910993b9c02718e6a935fc2d98b28c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3874b4f57e9757f7e352858c1f5a639fa55932d99809885436ceececb729f9d"
    sha256 cellar: :any_skip_relocation, ventura:        "c2274e38a05c23ac72771f6e6751bc84b3df51fb4931b996834e2c2a688a22b0"
    sha256 cellar: :any_skip_relocation, monterey:       "ba6a530833fd90ed433879bd3179a0bbc48a72763512649c39aadc0003b2ee00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "371f396ebb14b657852a71fcc473d9012a988c0140b5c878bae7c69d06edeb1a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
