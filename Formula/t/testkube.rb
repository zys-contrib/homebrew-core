class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.62.tar.gz"
  sha256 "413fdce2338612b6c18c5819f1d16a4c2732f117f93a2bccd6721335c540c6a9"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adbff10ac447865fe09082e02613ef32aeeb54d68090b037b4e4826d361cedd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adbff10ac447865fe09082e02613ef32aeeb54d68090b037b4e4826d361cedd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adbff10ac447865fe09082e02613ef32aeeb54d68090b037b4e4826d361cedd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "aba9eb5074779e074adf4940a89171bfa82cf2eb2c90b175acb452fbe702ee56"
    sha256 cellar: :any_skip_relocation, ventura:       "aba9eb5074779e074adf4940a89171bfa82cf2eb2c90b175acb452fbe702ee56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6d69aee2b1a356ae65b79cfb4129a2c337832ab74f638d8d617de0bd33886e"
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
