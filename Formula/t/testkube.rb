class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.51.tar.gz"
  sha256 "5c3ea34341518334885b1fc1b4d5452e7b65367afe14969d2135fb73baea0681"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e722e9b908591a2d16dcd888399b66c1a4cb152222e3ff511c4a9be4e9c783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e722e9b908591a2d16dcd888399b66c1a4cb152222e3ff511c4a9be4e9c783"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51e722e9b908591a2d16dcd888399b66c1a4cb152222e3ff511c4a9be4e9c783"
    sha256 cellar: :any_skip_relocation, sonoma:        "19e9fac71f503c9b13d7a1a6154d962980376242395dd05a6eaaf4c03470e2c2"
    sha256 cellar: :any_skip_relocation, ventura:       "19e9fac71f503c9b13d7a1a6154d962980376242395dd05a6eaaf4c03470e2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c30ae1d2ba7f32585c12f995f43b8091586b8c49a074884cf87193dddcbb8d"
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
