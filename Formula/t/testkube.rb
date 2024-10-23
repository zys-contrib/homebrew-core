class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.48.tar.gz"
  sha256 "409b97e9300b532eaa48d042975fee5e6a581607d8e934f595f1b20f4d38b2fc"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49da19d50c4007a023a01175c66b8e445e09c5cc823f4a2eee21407070708404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49da19d50c4007a023a01175c66b8e445e09c5cc823f4a2eee21407070708404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49da19d50c4007a023a01175c66b8e445e09c5cc823f4a2eee21407070708404"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4380ba1ba5487bff08627d7be847b04551d9f93370d876f91edea6c96a74f89"
    sha256 cellar: :any_skip_relocation, ventura:       "e4380ba1ba5487bff08627d7be847b04551d9f93370d876f91edea6c96a74f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bae3b8f2d43ba01726e39f21288e651be852cb276c621244ab6a6fff7453d79"
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
