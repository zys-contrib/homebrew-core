class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.55.tar.gz"
  sha256 "769528c39aaa924862cfd1dd4691a9b952c1b1a17ef271969a7a5265ef335355"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3bbc8430a9f28add71f3aebc08eb93efbd90318d99626696af81c54fcc07ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3bbc8430a9f28add71f3aebc08eb93efbd90318d99626696af81c54fcc07ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc3bbc8430a9f28add71f3aebc08eb93efbd90318d99626696af81c54fcc07ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba2511fd101b918ded0839e74767e7f9a5484d398412151f5f92b040f749e621"
    sha256 cellar: :any_skip_relocation, ventura:       "ba2511fd101b918ded0839e74767e7f9a5484d398412151f5f92b040f749e621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e37ff4e992d2ade9b4c66dc40659e02ac58907a1b81796ea18938120a63aba0"
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
