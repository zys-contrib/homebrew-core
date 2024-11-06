class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.59.tar.gz"
  sha256 "791d52906b27848b2c12f2510488eaf5406c34bd0734a019e3c7ee4cee8c6bd7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ff00fe8b48c4d2497d26286e24a2e8fd6d39bb16424cde60fa88ec2021badd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ff00fe8b48c4d2497d26286e24a2e8fd6d39bb16424cde60fa88ec2021badd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7ff00fe8b48c4d2497d26286e24a2e8fd6d39bb16424cde60fa88ec2021badd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e21b5c2b7044036433505efcb52530ee7c692f4eb0ebcdb8e111f378aacae12a"
    sha256 cellar: :any_skip_relocation, ventura:       "e21b5c2b7044036433505efcb52530ee7c692f4eb0ebcdb8e111f378aacae12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6c66d72a1c2946f1b8d7628ff54a934e8cb8612795efa99a33cc5269a838e0"
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
