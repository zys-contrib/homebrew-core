class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "2235aafc17b5c885ba6535446b9e1a47f46fa68cbc5f6099c9f7d8b1d5d025e7"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49fe53ebce3fcc0ebef25865166f1d7a6573b28524e6fd8df8b2f885660dd7a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49fe53ebce3fcc0ebef25865166f1d7a6573b28524e6fd8df8b2f885660dd7a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49fe53ebce3fcc0ebef25865166f1d7a6573b28524e6fd8df8b2f885660dd7a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b050e681113ad5624d64a161ee058900121a918347a7ff38a774bce66b7ec4f"
    sha256 cellar: :any_skip_relocation, ventura:       "7b050e681113ad5624d64a161ee058900121a918347a7ff38a774bce66b7ec4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf1377acb05c8cf5620450620f2fc290f66146cb42458a3c1b04e2001e34006"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
