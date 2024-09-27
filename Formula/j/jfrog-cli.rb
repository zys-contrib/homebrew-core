class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.70.0.tar.gz"
  sha256 "0bb7e009a9148026cc5e3acd93a692d72841da42fdd301e0892a9f6e1d949db9"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59c33e87afc16de03dfa88d64107adb6176765761dd922d6c92fa26916ed2ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c33e87afc16de03dfa88d64107adb6176765761dd922d6c92fa26916ed2ae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59c33e87afc16de03dfa88d64107adb6176765761dd922d6c92fa26916ed2ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca7d881181dbd01348423b3c8b82bc21879f4274a93abe8cfe41815195fec20"
    sha256 cellar: :any_skip_relocation, ventura:       "9ca7d881181dbd01348423b3c8b82bc21879f4274a93abe8cfe41815195fec20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac655c94937192a60a86b46e2fc2de77784d26cadf1ddba253dea9234cffe6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
