class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.62.2.tar.gz"
  sha256 "ac80471d3d4eb6c0a2f3e1be9c5a6342fbf1a9b56d56ec2909e885c8efed3215"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66a6bbf626d8e0e9a3d3ef8642432bfc7a060b8ad81de23df1e8f25c898656a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f419190e7983647a1e855cf047002af42a1ca39e0021813a263789e11bc55e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b9b7886b1f970597e0c605019693022713de4cdeb6ca65cf7d8056ae50df4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d24bb4b0719f7eeaf4d137d9f28e923f1a8bd4df56c55d5c7ece94fa3211372a"
    sha256 cellar: :any_skip_relocation, ventura:        "346d2e571a64fcd52977a1028f4645e7fa71f8d6945ef0e77fc4b5884c14956c"
    sha256 cellar: :any_skip_relocation, monterey:       "83ac7ecda33c687dc3085bf6e2b7b410dc212bd35c588dd8a79d50311a044f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d1b6f81144d88e0cfe609a5287c4c4005ba5d1107e1ee4606e4315816311bd5"
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
