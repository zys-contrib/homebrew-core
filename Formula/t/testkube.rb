class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.53.tar.gz"
  sha256 "86c783f2c056ab3410be2b484e3bfc89df4969c5d468d3e83495d63c82853308"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e9345238675dd02832ccbfd28ca7aab041c1f835981ca05bdde6a8e7e58637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e9345238675dd02832ccbfd28ca7aab041c1f835981ca05bdde6a8e7e58637"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63e9345238675dd02832ccbfd28ca7aab041c1f835981ca05bdde6a8e7e58637"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ceed7980fdde3f703cf677c374e7d9eb774e74e2ba50b2ba67d7dba0316df0"
    sha256 cellar: :any_skip_relocation, ventura:       "19ceed7980fdde3f703cf677c374e7d9eb774e74e2ba50b2ba67d7dba0316df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a9c3991dbe625e7d4e23e5c9dc9f195f9c161a5b3a472d686d4a5427d2b570"
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
