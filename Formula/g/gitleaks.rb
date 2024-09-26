class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.19.3.tar.gz"
  sha256 "80b986a3a650fa08b8e864f57b4dffccaa50e6f9623d46a6b7f47c8dbad5da99"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3f4cd1ab5fee5148212c1fa10981abc42c285e9cb5bd0aa61d89147664c17f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab3f4cd1ab5fee5148212c1fa10981abc42c285e9cb5bd0aa61d89147664c17f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab3f4cd1ab5fee5148212c1fa10981abc42c285e9cb5bd0aa61d89147664c17f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6537a57e2e461a0548f332347b7c68de5682565c6f719dc24a8a532e550ee8d0"
    sha256 cellar: :any_skip_relocation, ventura:       "6537a57e2e461a0548f332347b7c68de5682565c6f719dc24a8a532e550ee8d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d00bd9df8c01942398534b557dff7d44360bb93f3640fd01b36a3246a438aeb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
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
