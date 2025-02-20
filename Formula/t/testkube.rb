class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.94.tar.gz"
  sha256 "aa9e03b7b9184a949e25c64dd2a24bc1c4db4f8a92b31e2b267551bd70cb60ae"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "842a6ae2760f330f2b348a3b410e5b7b08ccc59accedf5ea03ef1ae37dbd1bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842a6ae2760f330f2b348a3b410e5b7b08ccc59accedf5ea03ef1ae37dbd1bc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "842a6ae2760f330f2b348a3b410e5b7b08ccc59accedf5ea03ef1ae37dbd1bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e661aff91b5af7b0abf2a84586389c7174f796b6212f16e3c43b5e520d9f32eb"
    sha256 cellar: :any_skip_relocation, ventura:       "e661aff91b5af7b0abf2a84586389c7174f796b6212f16e3c43b5e520d9f32eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbca451b9733485bc53bb2bff7855a29b3a4077211495bd4c8054d178bec699"
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
