class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.38.tar.gz"
  sha256 "02808c0352337e0757ba161d73b1f0c44e2d7ac9622ce0cc60bfaf5432bbbb49"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fda0c85432e46a9f36af4ac36652b432010669d26bc6377354a473b6dd413d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fda0c85432e46a9f36af4ac36652b432010669d26bc6377354a473b6dd413d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fda0c85432e46a9f36af4ac36652b432010669d26bc6377354a473b6dd413d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "25c7a422e82296075b7f5dbe4d51adbc831504c3bf80833b6bfe80222de93818"
    sha256 cellar: :any_skip_relocation, ventura:       "25c7a422e82296075b7f5dbe4d51adbc831504c3bf80833b6bfe80222de93818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce9a506247010a32edf2fbfdbd00b9737975b860ce4d06fba266f5433492be6"
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
