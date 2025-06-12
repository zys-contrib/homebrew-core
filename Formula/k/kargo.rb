class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "0a7b347c74a8659ee7c34aa255ba6f9b46790f064c50b2461486672ba5c73e12"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4815b27dfc12f1145648ea8ea94c5bd1f885fd1489fdf7e3c9afab78f874671f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f313a65a1e9c37ea3d307d83d710f9566b4c4322ff8929fb3e7389ccbb9f053"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f38d5f1371fe81592637bc4fa72f645193aac3ebcb0de2d60ee739c63019e4cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a0aab68e1411a32aff317a8b5aa1427cc01c97396120d03184fed3945591e45"
    sha256 cellar: :any_skip_relocation, ventura:       "876d3765540618a177c316128a1f964b706b8e7891b8bb2bfda757ece7ae665e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "751ae23849ba36ad41116a210abf0b3af5a782d4adf8ca1b10f48119c5436655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db968cd65acefb348c5e19f25017d920885740c9275b2777814a847e49ff515"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
