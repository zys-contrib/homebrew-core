class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.127.tar.gz"
  sha256 "b4505c998bb3f246d9b27839ef33beb43377cb8ca54aa512a9e9499e5dca2145"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd340659097f1e15c873c6bf79eacb559d5a5a213905cf07d54c7ced69003f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd340659097f1e15c873c6bf79eacb559d5a5a213905cf07d54c7ced69003f16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd340659097f1e15c873c6bf79eacb559d5a5a213905cf07d54c7ced69003f16"
    sha256 cellar: :any_skip_relocation, sonoma:        "68f01745791803ef224de8da8b6012f0eecd2a83c2105504d4e0962e6c36156e"
    sha256 cellar: :any_skip_relocation, ventura:       "68f01745791803ef224de8da8b6012f0eecd2a83c2105504d4e0962e6c36156e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08d4284b42eb101cc69fc95510a9f87fdb66fa80116008950a6aac402bda6c03"
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
