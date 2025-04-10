class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.1",
      revision: "142282b584bdf5f579e4571703defb3a18e535f2"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b345d983d349d0c56845a9e84f8ae12c5152b5b8f8652abc3c94dc2e4799d5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b604ed4cd0f795a7383430c87042d9e152eda2177e225fe11f37879c98e6b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87ba24af16dd135cf107db5cd3f480928747083476c0a0d49f52c24785f0de77"
    sha256 cellar: :any_skip_relocation, sonoma:        "a33e733555290e3b1d1e208cfb4369cea24bffafc321edfdcbbdda11466d7595"
    sha256 cellar: :any_skip_relocation, ventura:       "7d8018397a99591766d5e053339d088ddab7f2e2ddaff30f15a4c1264d9b1ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28457cf1a2cc016aca765a43444ae56916cdc6dab708f5ff1f5a7d78c628f4c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
