class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.150.tar.gz"
  sha256 "7f5c06c223f8e888ed2c5f341cf03de7f3a29271fdf478173351e7647a471d8f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0077f52b60be881eb5541f59ea22867feefd6ae3ad47d005f59e791bfdfbe250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0077f52b60be881eb5541f59ea22867feefd6ae3ad47d005f59e791bfdfbe250"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0077f52b60be881eb5541f59ea22867feefd6ae3ad47d005f59e791bfdfbe250"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8e1f9016062cc6c232d57ebd729703c4d613bad8f4c0b60a5af7fcea94f5e3a"
    sha256 cellar: :any_skip_relocation, ventura:       "e8e1f9016062cc6c232d57ebd729703c4d613bad8f4c0b60a5af7fcea94f5e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2eebc78497dbbb95df762aae5c02a63ffa5c14efd4f669892342a83cd5bda2"
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
