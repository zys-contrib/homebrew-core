class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.136.tar.gz"
  sha256 "36aa211cfe0ce0c66f2dc06061f3a8dbdb3d2ef128907eb35ef611dc6f186947"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e245cdaa799fe48ed6969f145b9f0d6f9a299e41bdc35d9cbfecd95321d844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e245cdaa799fe48ed6969f145b9f0d6f9a299e41bdc35d9cbfecd95321d844"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03e245cdaa799fe48ed6969f145b9f0d6f9a299e41bdc35d9cbfecd95321d844"
    sha256 cellar: :any_skip_relocation, sonoma:        "d744af6fa9aa0716d5fb961cb8257b65453fc036282b09b2a62ef52f08393dca"
    sha256 cellar: :any_skip_relocation, ventura:       "d744af6fa9aa0716d5fb961cb8257b65453fc036282b09b2a62ef52f08393dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c282b0b0fc372dfc0bc4b12db58c41b94c4e2c4696d20f3a52ad339719a21ef"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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
