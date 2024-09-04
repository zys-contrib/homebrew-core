class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "9c6b571627392555362b98df1d3d21b4505a8334667d1f57c1363aacf301dddf"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66720c595775422ea0bfa0833628dca7b41bc515babf070de037843e2263378b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66720c595775422ea0bfa0833628dca7b41bc515babf070de037843e2263378b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66720c595775422ea0bfa0833628dca7b41bc515babf070de037843e2263378b"
    sha256 cellar: :any_skip_relocation, sonoma:         "51b5a732f58c58ea4dc0e6f70cb7e263b7f9016cf3324738781cb849e285f94e"
    sha256 cellar: :any_skip_relocation, ventura:        "51b5a732f58c58ea4dc0e6f70cb7e263b7f9016cf3324738781cb849e285f94e"
    sha256 cellar: :any_skip_relocation, monterey:       "51b5a732f58c58ea4dc0e6f70cb7e263b7f9016cf3324738781cb849e285f94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7d2a0e5cdf1abf1dbd6343dcb1e704de3c49d8229dcf1e3d0bfa839d440eee3"
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
