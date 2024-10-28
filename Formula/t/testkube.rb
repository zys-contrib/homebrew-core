class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.49.tar.gz"
  sha256 "6c12d7b95319e2ab4876318518fe7e4c2a71a447f4e674fce0c1cd335d370ac2"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27990987544356d642855faed6d31496a2a68df52386d5100126eda0815fc2c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27990987544356d642855faed6d31496a2a68df52386d5100126eda0815fc2c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27990987544356d642855faed6d31496a2a68df52386d5100126eda0815fc2c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "779d7546139f66bf4afa4ddaa45dcb7a89af1e13cdd84c4c264ca1c66fd0f5fd"
    sha256 cellar: :any_skip_relocation, ventura:       "779d7546139f66bf4afa4ddaa45dcb7a89af1e13cdd84c4c264ca1c66fd0f5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71124a5cf64bb0271a4f1c41a8a68fa977ad28e242098530296df48d52f06e9b"
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
