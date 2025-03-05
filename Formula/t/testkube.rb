class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.106.tar.gz"
  sha256 "6fc38c19e0dd653385c688f6947ec475ce57164390430af97890c0ed647ad4a9"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cfa81d1089e231109c8747c2efc1542cc70171aa26855395957a7e016cbda0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cfa81d1089e231109c8747c2efc1542cc70171aa26855395957a7e016cbda0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cfa81d1089e231109c8747c2efc1542cc70171aa26855395957a7e016cbda0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c098f5769e2543346d7053af893ed3db6acb2164ad6dc40fd145d593aeb0facb"
    sha256 cellar: :any_skip_relocation, ventura:       "c098f5769e2543346d7053af893ed3db6acb2164ad6dc40fd145d593aeb0facb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd7083aaffc5c0d672e6467f800878c9dd7d4b4e05e45c1dc7d6b265a53ef60"
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
