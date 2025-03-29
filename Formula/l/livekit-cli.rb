class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "50ace1d37d6ffd80dd186dc685a43812f85a0bbdd6b006327dbf26b802a04958"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d6c5ff4844f6d3da36ea78a7ac94fc8b1ad086a66e27c997a8aef81dc210a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d6c5ff4844f6d3da36ea78a7ac94fc8b1ad086a66e27c997a8aef81dc210a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d6c5ff4844f6d3da36ea78a7ac94fc8b1ad086a66e27c997a8aef81dc210a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "1179da87f66c3d90513b012262168a28e2c2976d32bfd337984f45ca4c1f68f7"
    sha256 cellar: :any_skip_relocation, ventura:       "1179da87f66c3d90513b012262168a28e2c2976d32bfd337984f45ca4c1f68f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5431e35b11f5920ae906e70b52c6937ce1d445a2a7eb5d929072aa3e94791d5"
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
