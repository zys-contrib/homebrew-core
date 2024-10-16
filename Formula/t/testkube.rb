class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.41.tar.gz"
  sha256 "d572e386850ccac4205a74c4d075a809a4d178d6d10a349bd2c96c4c92a0ec63"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d255206b4e1ab32e29129a9723f6e7810c3dd9be645405e74f545e21148ca9a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d255206b4e1ab32e29129a9723f6e7810c3dd9be645405e74f545e21148ca9a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d255206b4e1ab32e29129a9723f6e7810c3dd9be645405e74f545e21148ca9a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "11088ce9dd7f8e01e3048edc94385e3193dea954d6eb8038644d5da31607143c"
    sha256 cellar: :any_skip_relocation, ventura:       "11088ce9dd7f8e01e3048edc94385e3193dea954d6eb8038644d5da31607143c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b2dc3a625ba285a1bebaeb1065fcfcf4dff95e872fd67ebe565b6fc6d72282"
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
