class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.36.tar.gz"
  sha256 "143a3306ffd8efbc32b9cfe16359f42813a80d072ac84a500a5d94e2dc76e01e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab5df400a14db1aee67dc8df5c725ed568d339d6adc847fa54b6ffb580c18ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab5df400a14db1aee67dc8df5c725ed568d339d6adc847fa54b6ffb580c18ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ab5df400a14db1aee67dc8df5c725ed568d339d6adc847fa54b6ffb580c18ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfc9ca368a09451c2b7df12863c59973dcf13990335eca0acf9b304296e106f9"
    sha256 cellar: :any_skip_relocation, ventura:       "bfc9ca368a09451c2b7df12863c59973dcf13990335eca0acf9b304296e106f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1c123f094f9dfbb0a43fa024ab655913dc0e3b78d093d4981298e8a0a99324"
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
