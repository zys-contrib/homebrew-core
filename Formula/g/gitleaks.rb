class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.22.0.tar.gz"
  sha256 "906a3f9d402782a6e356ea3a5c737a0392bc84e860af5cee9ec942c074d771bc"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156aa32fce2f87235e2148b62155e159843fe1d55331e9b5c3cacd8a7d1e8d9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "156aa32fce2f87235e2148b62155e159843fe1d55331e9b5c3cacd8a7d1e8d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "156aa32fce2f87235e2148b62155e159843fe1d55331e9b5c3cacd8a7d1e8d9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b7114d0490c17c0467357848e128ab8afc4e4a4903e91c8d6eb8f4413e8f40"
    sha256 cellar: :any_skip_relocation, ventura:       "c8b7114d0490c17c0467357848e128ab8afc4e4a4903e91c8d6eb8f4413e8f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f3f5385392de48365f6d14059c3f9b9bdccea9b84b5e2cfdaf9b5e6eb26c1d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeef61dc214e36cbc4cee5eb6418e38d"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
