class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.116.tar.gz"
  sha256 "8fdfeba3074ba760b4062a8d6d74090595794836a7e0b168cd9d39a272351f06"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e462f2062ae38f337671fff06fe39f327e20e43ac88db1b737f89698eabe656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e462f2062ae38f337671fff06fe39f327e20e43ac88db1b737f89698eabe656"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e462f2062ae38f337671fff06fe39f327e20e43ac88db1b737f89698eabe656"
    sha256 cellar: :any_skip_relocation, sonoma:        "693b27c7a8706d615d16e715b27fe82c8d0f348925b0f784725d82c5bf043cb8"
    sha256 cellar: :any_skip_relocation, ventura:       "693b27c7a8706d615d16e715b27fe82c8d0f348925b0f784725d82c5bf043cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27ffbb710311de3326be20a15b568befeb39e1f3eaa6475604dbdd4745b90a90"
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
