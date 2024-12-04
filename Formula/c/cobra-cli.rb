class CobraCli < Formula
  desc "Tool to generate cobra applications and commands"
  homepage "https://cobra.dev"
  url "https://github.com/spf13/cobra-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9c9729828a035eff012330d5e720eec28d2cb6a1dbaa048e485285977da77d15"
  license "Apache-2.0"
  head "https://github.com/spf13/cobra-cli.git", branch: "main"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cobra-cli", "completion")
  end

  test do
    system "go", "mod", "init", "brew.sh/test"
    assert_match "Your Cobra application is ready", shell_output("#{bin}/cobra-cli init")
  end
end
