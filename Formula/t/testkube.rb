class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.28.tar.gz"
  sha256 "a2417bd65a3d0c05db4e4d1812f4bfac89fcfce3f3e807bba553eb95c7e5e6bb"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33cd3306bee7ecc7b353026fcfef3938f30f26733aea876daff8c7ab9a6d08a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33cd3306bee7ecc7b353026fcfef3938f30f26733aea876daff8c7ab9a6d08a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33cd3306bee7ecc7b353026fcfef3938f30f26733aea876daff8c7ab9a6d08a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d85a8b23784d4419a977c1e1c8f4e8fef6b1c500049a0cd90e79b70c7afe75e5"
    sha256 cellar: :any_skip_relocation, ventura:       "d85a8b23784d4419a977c1e1c8f4e8fef6b1c500049a0cd90e79b70c7afe75e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3e625a46119c1b6ea282777890c64f177ece186a69b6afe89c1746383f50ed"
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
