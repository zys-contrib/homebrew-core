class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v17.1.1.tar.gz"
  sha256 "26b0f1357b6bc4dc5c53b70c9634895c181f89b3529c62eea1346e247ee74003"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efafe6f041ad282e2ee42e0340044b19a14dc053b9e73b9d50e1727b4a15d160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efafe6f041ad282e2ee42e0340044b19a14dc053b9e73b9d50e1727b4a15d160"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efafe6f041ad282e2ee42e0340044b19a14dc053b9e73b9d50e1727b4a15d160"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e0e57a9d67ca2be661f69fba2ca212e753ad825e26e416518f95804af609d00"
    sha256 cellar: :any_skip_relocation, ventura:       "4e0e57a9d67ca2be661f69fba2ca212e753ad825e26e416518f95804af609d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4adc5bcf99f37b8dab60c4d6f4132b97459cc643d0db1aa67edaf7100efd82ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
