class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.61.1.tar.gz"
  sha256 "1a76d3a1d5cdb97d0c5fdb724d362ec906c1eb0ab72300a2344896435cad4c66"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfec62b5451c45c165b56c5ddff0ca94d5f4c6ec314724b7e21a42c2516889ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a07ca22e14ab8a9de5497533c23aadffe1a06d8cbeeb1d3b75422cd0e680b0df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f0027a54772285e0ffe5b026b4f657c120dbe78af085c7a509ce6413c4ce945"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ffeccc87557749e54ffcbcf8f5ab0a08d36078660cd7c90cc682b29e69324f2"
    sha256 cellar: :any_skip_relocation, ventura:        "9ddf0699c642c5f0acac47f5799843639792b1d5b09501a84d2a24187f63f7fd"
    sha256 cellar: :any_skip_relocation, monterey:       "fc00de1ff085b6773953db594ee432848eaa395e2eccd7ecfc0f3bd8bf09706e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e082561e0f2b6578a6ae6d6f097fd03e6dc82789b89f9e993ff6573ef3d4375"
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
