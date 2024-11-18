class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.65.tar.gz"
  sha256 "6db7490081219c0819e7ed630ca97bfcb27560624ad276e31d309673e574a871"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849568735fb0042a07c988c948d9ebe93e3c2e161e46a11ec995cfa52bd25eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849568735fb0042a07c988c948d9ebe93e3c2e161e46a11ec995cfa52bd25eaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "849568735fb0042a07c988c948d9ebe93e3c2e161e46a11ec995cfa52bd25eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "97ed708cc65c3d39306c1f3afe44d8c2b6e69944675fbef1a58b5ab72c42443d"
    sha256 cellar: :any_skip_relocation, ventura:       "97ed708cc65c3d39306c1f3afe44d8c2b6e69944675fbef1a58b5ab72c42443d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc3704f0b379620630f49e00fe7bb59787fb44a547e0f3d224eefdbfedb302a7"
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
