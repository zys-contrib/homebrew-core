class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.140.tar.gz"
  sha256 "84273313daf28e71803a06653a44cfa7b4512222440708636cf3cfa260f8f304"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e40864032aeee7571bdeed6c5523b9ddd52903c43931d2dcad7c408b43b430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6e40864032aeee7571bdeed6c5523b9ddd52903c43931d2dcad7c408b43b430"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6e40864032aeee7571bdeed6c5523b9ddd52903c43931d2dcad7c408b43b430"
    sha256 cellar: :any_skip_relocation, sonoma:        "e77c681b4c64e4d381f807ed487432e73ba716aebd95dacef938e69b8e08edba"
    sha256 cellar: :any_skip_relocation, ventura:       "e77c681b4c64e4d381f807ed487432e73ba716aebd95dacef938e69b8e08edba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96912de570953dc5653e681bca9d9fbaeb74e19d67f951e79e2f83d90971137a"
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
