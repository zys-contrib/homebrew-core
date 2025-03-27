class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.127.tar.gz"
  sha256 "b4505c998bb3f246d9b27839ef33beb43377cb8ca54aa512a9e9499e5dca2145"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8ad37824bbefb8d44845bf770b62e1efd526bda0b527382eba7f50f1d12abba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ad37824bbefb8d44845bf770b62e1efd526bda0b527382eba7f50f1d12abba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8ad37824bbefb8d44845bf770b62e1efd526bda0b527382eba7f50f1d12abba"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81ef069dc34a4dd44c008d50432570e958823144495b909af1bbc8462183453"
    sha256 cellar: :any_skip_relocation, ventura:       "d81ef069dc34a4dd44c008d50432570e958823144495b909af1bbc8462183453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a1326ed8e03231136dd96724264b34bbaf0d8829889e02835d4b93a47c280e"
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
