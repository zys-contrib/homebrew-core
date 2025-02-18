class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.89.tar.gz"
  sha256 "0878e71785c3a293c9969c95a1865219e912c6b1fb4b4ef66a61fc44434ac046"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63d6bbe8b519e6798336c2aeb9c4c5b4577aac8b20a2c919a81082db1f8a5149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63d6bbe8b519e6798336c2aeb9c4c5b4577aac8b20a2c919a81082db1f8a5149"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63d6bbe8b519e6798336c2aeb9c4c5b4577aac8b20a2c919a81082db1f8a5149"
    sha256 cellar: :any_skip_relocation, sonoma:        "053ad0f858bf6ab91178eb4c88a8fefee6037247e47a9c788eb5692398c248eb"
    sha256 cellar: :any_skip_relocation, ventura:       "053ad0f858bf6ab91178eb4c88a8fefee6037247e47a9c788eb5692398c248eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a96db9f4d3511ec5e007b42df4f8db7844696e95fe265111e6790d7d83bd7a1"
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
