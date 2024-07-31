class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.0.15.tar.gz"
  sha256 "744500a28542cde97cb712475763910271ebaaad4e91e7c3b766dc73e2f78c30"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28239a572c9e33906b66c8b1bcecdfab7953bce7069adf48ca9be705fdad5917"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3c42268dd27ed1f9fd1c29288a4da1f8cf91fb5e94f23170ebf429eb26803da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d00fc295168eea81837cbad7781d391fbbacabbeeefe0371c190ee30f5fd523"
    sha256 cellar: :any_skip_relocation, sonoma:         "f597c39bd1528b8ea81985e3ba17d06d3995d3c38cd07ac32378719d84a4bf16"
    sha256 cellar: :any_skip_relocation, ventura:        "8c2962836b0232eb077e364ee5f1539a7f3a42967d79909565e32aada111bb72"
    sha256 cellar: :any_skip_relocation, monterey:       "ee692130a21f26a255bc062c76f03b888641c34ab6e1e7e07a268e4cb5446088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e36ad431d031e68134bd0d3cbd88ababa06f342aca365074ac925fe6d958b08"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
