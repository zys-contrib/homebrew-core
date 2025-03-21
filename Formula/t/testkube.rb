class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.120.tar.gz"
  sha256 "f004ecfb398bcefb66df1c13ede351880673b22ae0236fc3188af5c6efba67da"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6bc16cbfdbe7bd70550e6ae0199da60e18c1b2b04f5594ea888561366e1fe22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6bc16cbfdbe7bd70550e6ae0199da60e18c1b2b04f5594ea888561366e1fe22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6bc16cbfdbe7bd70550e6ae0199da60e18c1b2b04f5594ea888561366e1fe22"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf029f6c0a1414eb4b52cdcfa38fb945497beb1973215b922bf589bd2e4798ee"
    sha256 cellar: :any_skip_relocation, ventura:       "cf029f6c0a1414eb4b52cdcfa38fb945497beb1973215b922bf589bd2e4798ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a64a4c53e382d0df7c977fe8565c7dc3f6c59da14e79f90491e7bcb0d92dfdb7"
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
