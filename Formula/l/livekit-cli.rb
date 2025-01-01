class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "e6e6bf11930e47356248fd1b7e90549692ee415a77caf8f9d8b15ae471a31420"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25049a3257cbf11dbf1347d33e40b1004a375cec67e34fde360af19b2501e2b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25049a3257cbf11dbf1347d33e40b1004a375cec67e34fde360af19b2501e2b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25049a3257cbf11dbf1347d33e40b1004a375cec67e34fde360af19b2501e2b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "777ece92c5ef143c71c2cbfac3251dcc8462f1ab6eeb9856b41b32d3cb5375ed"
    sha256 cellar: :any_skip_relocation, ventura:       "777ece92c5ef143c71c2cbfac3251dcc8462f1ab6eeb9856b41b32d3cb5375ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec48d42c3939c62177600678d1e328db7584af11545167396e84af94b2126ad"
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
