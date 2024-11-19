class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.67.tar.gz"
  sha256 "000b1feae638cdcf982d8149353cb9a3662c061f5814735782f113ea200c55f7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ef0f44529f1eabcc71e0e2923a630abda098bb53e88b3c1ddd85a02fce1d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ef0f44529f1eabcc71e0e2923a630abda098bb53e88b3c1ddd85a02fce1d74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3ef0f44529f1eabcc71e0e2923a630abda098bb53e88b3c1ddd85a02fce1d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a1b32e33fd91be7d47e8cc330a70d8479691b22809bfedadf6ce52749b8f04"
    sha256 cellar: :any_skip_relocation, ventura:       "14a1b32e33fd91be7d47e8cc330a70d8479691b22809bfedadf6ce52749b8f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3f90763c15ff495659555c6ba24685c99a7de60d9ebc2052769ff0da1ead680"
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
