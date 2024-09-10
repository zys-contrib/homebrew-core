class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.18.tar.gz"
  sha256 "9eae5c23f80ce933eb219af8920fde6cb6e9bfca10bd2395bb41d4591611d51f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fbebb417e0f4eef8731835b771be442af0db7d3f25fd852298ea064d77183cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fbebb417e0f4eef8731835b771be442af0db7d3f25fd852298ea064d77183cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fbebb417e0f4eef8731835b771be442af0db7d3f25fd852298ea064d77183cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccd6a64c0adc810f5e480afb52c301233811e103d12e3d57a1eaaacb4d34af93"
    sha256 cellar: :any_skip_relocation, ventura:        "ccd6a64c0adc810f5e480afb52c301233811e103d12e3d57a1eaaacb4d34af93"
    sha256 cellar: :any_skip_relocation, monterey:       "ccd6a64c0adc810f5e480afb52c301233811e103d12e3d57a1eaaacb4d34af93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f884c2b4eb0cef5163deb5959219c1f4f039c1f95e15f80408d602b0123e59f9"
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
