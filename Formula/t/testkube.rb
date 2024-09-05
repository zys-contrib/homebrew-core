class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.11.tar.gz"
  sha256 "ae2bb3c026b2dcd178500d1c3711f3544c304f579c3c48061a99847a98aebd9b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32221bfdd4beda12764f9bd34b03d051981e218653dd7b69bb1de25e936e15b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32221bfdd4beda12764f9bd34b03d051981e218653dd7b69bb1de25e936e15b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32221bfdd4beda12764f9bd34b03d051981e218653dd7b69bb1de25e936e15b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "04c761a7c0a991563ee6830642f174cd1c6662d50cb58598bb37e48c205fddff"
    sha256 cellar: :any_skip_relocation, ventura:        "04c761a7c0a991563ee6830642f174cd1c6662d50cb58598bb37e48c205fddff"
    sha256 cellar: :any_skip_relocation, monterey:       "04c761a7c0a991563ee6830642f174cd1c6662d50cb58598bb37e48c205fddff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d78b4a91e47e58673736824a71a9b7bcb65aab8cc3b262a74f3f2c78dda26ae6"
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
