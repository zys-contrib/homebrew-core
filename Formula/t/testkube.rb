class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.40.tar.gz"
  sha256 "f654637e89dc7e426acb8a7aa39eb266da566db26ce0ae01b63a9f06f24d71e9"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e2159385a2ae2cd6db5e950fac76828b70163b5bf3039c929a2141214dcd424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2159385a2ae2cd6db5e950fac76828b70163b5bf3039c929a2141214dcd424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e2159385a2ae2cd6db5e950fac76828b70163b5bf3039c929a2141214dcd424"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30c90298bef338b7635a7b2aa0ab9a3d45997d96e62fbcef0b20564f4119d43"
    sha256 cellar: :any_skip_relocation, ventura:       "d30c90298bef338b7635a7b2aa0ab9a3d45997d96e62fbcef0b20564f4119d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9edc78fb3247b5dad0b174e423bf8180d44cf760ba90afac5da584d16f440fdd"
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
