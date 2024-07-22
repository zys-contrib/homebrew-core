class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.44.1/cli-v1.44.1.tar.gz"
  sha256 "59502833637aadb7c88dadc3c2f826cbe185a8fe7c0b90d82ccaca1da9d5dcf6"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22f1b3c66f82255536c3dee172f8851d34b71fdc96ea482c9c2a68400ad70fcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "127bd6ca5d6407ef6cc16dcd53e3d7016416aa8b916119b5f32f06ad8ad8df4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b52a4df273608d7ad14541e23353b507eed1809edba019dcabefb021b13a70b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3031b17ed264e8f4a35f8ddca5a8706782ededdd173555111f6a5196d7a542e6"
    sha256 cellar: :any_skip_relocation, ventura:        "095f43d84a530d676d799ef12bdf127e735af23543e67d128d94e54688a1254b"
    sha256 cellar: :any_skip_relocation, monterey:       "cd4239a73bc7dd9f6fa7fd9791dc52d47c1defe5a2ee97e600bb6e9ee8b4f10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a271eac4fd6c893742dfd1948f25ea4b19e2206e7637b79ead834a39e534407"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
