class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.15.tar.gz"
  sha256 "12f5ee40fa6a59807cfcc942e3d139260b9c86802269b03aed99e18cb5f60449"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cde8e9ff2bb2aada926d23a626ffd9686c0f1bfbc7f4292406bbd54e1f36e6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cde8e9ff2bb2aada926d23a626ffd9686c0f1bfbc7f4292406bbd54e1f36e6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cde8e9ff2bb2aada926d23a626ffd9686c0f1bfbc7f4292406bbd54e1f36e6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a0becfd4f74c5eb2400e97ee92dc478ea85db15c25b2f79b10d7291f47c47d4"
    sha256 cellar: :any_skip_relocation, ventura:        "1a0becfd4f74c5eb2400e97ee92dc478ea85db15c25b2f79b10d7291f47c47d4"
    sha256 cellar: :any_skip_relocation, monterey:       "1a0becfd4f74c5eb2400e97ee92dc478ea85db15c25b2f79b10d7291f47c47d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ac4705bc2f3c093e6cc91fc7d5eff0d0211d199b1ea63ae557aaf39017d1f5"
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
