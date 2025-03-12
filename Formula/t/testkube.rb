class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.112.tar.gz"
  sha256 "04350a4752080d717e6c19ea03f1500cdaceaa5ebbf83d5b2fb0201b3e77bd86"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4113f37f7e5b63d4e5479a5f11b5b88bb904b7051a976329890992fe5f59681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4113f37f7e5b63d4e5479a5f11b5b88bb904b7051a976329890992fe5f59681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4113f37f7e5b63d4e5479a5f11b5b88bb904b7051a976329890992fe5f59681"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba27a05dc8d8b4d02226c63897ae985cc7af364d4977ceb78e13677127730767"
    sha256 cellar: :any_skip_relocation, ventura:       "ba27a05dc8d8b4d02226c63897ae985cc7af364d4977ceb78e13677127730767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81268bae8d827e98272a27cc2afa557c566158e2d3e49668ad2a356535916eaf"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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
