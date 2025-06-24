class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.160.tar.gz"
  sha256 "e989a97a488e5c5baa2ac16d7fe62dc9019af75739d787c19f55b52e03b4e168"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97a35e9bd84f1739e23f9298e4b92828e68fa234e632978270737248174feb5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97a35e9bd84f1739e23f9298e4b92828e68fa234e632978270737248174feb5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97a35e9bd84f1739e23f9298e4b92828e68fa234e632978270737248174feb5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bd83048ddc8b23ff3848f42c969a6b3c091dbff9ff8ebc89850f54ba0bf6cd"
    sha256 cellar: :any_skip_relocation, ventura:       "17bd83048ddc8b23ff3848f42c969a6b3c091dbff9ff8ebc89850f54ba0bf6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e565b649e9ccc43ecea0d40287c8d26c9116edc997854a0226b7458d278158e5"
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
