class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.65.tar.gz"
  sha256 "8f4d48fb51b798654496f3977a016e741322f26fd563b7b3437bbc6006187c6d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e434b5365625ac270f865f7cb4e808e481c556b48a8bf33bca9275e3034cb9ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b28b477efb449616cbf2504e63f9f24b01c4e79e4a8a8dbb56651d4b4c8a99e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a415a6515e7c1be1a6916e2388d59ff1087bc9b84f55137ef8b697a308f068"
    sha256 cellar: :any_skip_relocation, sonoma:         "1abdcee03351d21bbcd06414427e617e8e616c94073fff80ceea9085d14d8fe6"
    sha256 cellar: :any_skip_relocation, ventura:        "ba1a36835cd397a205358b8b9e06e2f93e1eb54ca22231b04883bff64b937edf"
    sha256 cellar: :any_skip_relocation, monterey:       "59e5dd3ac462c1ff776fcca18c110a6d2742f643b7c0d87b1d1ca28eac00475b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b11370666e6890c6894312e2b305a417b15ade0f9b9e928ba25eaa7f94d8c08d"
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
