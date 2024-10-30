class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.54.tar.gz"
  sha256 "27634bf5d3b97a68a7369ea2045e7a1b3cee022a8efb378bc755453ff5645c65"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74503dbf9f358e3bf2ee95be50647caf29010152a0f30e1cf25c5c8b82bea4aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74503dbf9f358e3bf2ee95be50647caf29010152a0f30e1cf25c5c8b82bea4aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74503dbf9f358e3bf2ee95be50647caf29010152a0f30e1cf25c5c8b82bea4aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae45ba6d182ed31d3c2f96a469ed4c6b049974161408ba068c0b2e7aca07fda8"
    sha256 cellar: :any_skip_relocation, ventura:       "ae45ba6d182ed31d3c2f96a469ed4c6b049974161408ba068c0b2e7aca07fda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8333cb8585aca02284adce0e513ba01fa9fb566ad4379c11db2c00697e1c57b7"
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
