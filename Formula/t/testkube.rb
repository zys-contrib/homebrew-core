class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.25.tar.gz"
  sha256 "8248561991b9ee05fef9032b97ec60aab4658ae2ca3d7438598590175cdb5ccd"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d7f7816286a11513b659659c3ad869375d16bc4fb5245e02e9383935cfc04e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d7f7816286a11513b659659c3ad869375d16bc4fb5245e02e9383935cfc04e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d7f7816286a11513b659659c3ad869375d16bc4fb5245e02e9383935cfc04e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e65cc6f06b78f4edda41869e8e1d5c97d5269bda5ae6b797f573fcc46b941712"
    sha256 cellar: :any_skip_relocation, ventura:       "e65cc6f06b78f4edda41869e8e1d5c97d5269bda5ae6b797f573fcc46b941712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6806fa8b34c41bd5fe748955f57469666c76c62abd78856abc7020e622130c5d"
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
