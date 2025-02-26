class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.99.tar.gz"
  sha256 "376b9d57c9c609a7685db73309edb5162ec9b0f7957d042dcdb5e4b5d1e93210"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5917676653c5b85f2b4dacbefacb41e2cf886864a5c3913093963c0a60915ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5917676653c5b85f2b4dacbefacb41e2cf886864a5c3913093963c0a60915ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5917676653c5b85f2b4dacbefacb41e2cf886864a5c3913093963c0a60915ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb6c42e9a12c37aa32c48ee9e26ef703addedee12d2a572d4d5bb2ca6a6ce468"
    sha256 cellar: :any_skip_relocation, ventura:       "bb6c42e9a12c37aa32c48ee9e26ef703addedee12d2a572d4d5bb2ca6a6ce468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5d50b4cc7a55591abe002eb4c5eec985a6abeb071ba1f78e5fb07881b2a87a"
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
