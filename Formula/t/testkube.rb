class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.32.tar.gz"
  sha256 "a3ac6884e1516cd6baef56af45f423b8ec3eee4fbf6c4c222658ec668e9fe716"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e7b771ec8d86ed53759498bf3907db31ca922021de25044d3af916283531b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e7b771ec8d86ed53759498bf3907db31ca922021de25044d3af916283531b1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e7b771ec8d86ed53759498bf3907db31ca922021de25044d3af916283531b1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9666b234f35e48147664219676e63c25bafa376734ab137d1c3e9b6b5fa51296"
    sha256 cellar: :any_skip_relocation, ventura:       "9666b234f35e48147664219676e63c25bafa376734ab137d1c3e9b6b5fa51296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeec067031057d069cb0556b83caf93967ecf75df2c068308e0eb904e7c12eea"
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
