class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.13.tar.gz"
  sha256 "229fac40b0dd0bc8ff79e3a44ea60e0de74ccf353217494e2c3dcbdbf9caee97"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "895ea91bd7cca2215937c8478cd19a1f7923f8f4cc35929a4f04640cf9f5fcf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "895ea91bd7cca2215937c8478cd19a1f7923f8f4cc35929a4f04640cf9f5fcf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "895ea91bd7cca2215937c8478cd19a1f7923f8f4cc35929a4f04640cf9f5fcf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b988c62d7ee7a92b069e2c21aa1bfb9288432a4f9b035f2e6bd2ba3746d6407"
    sha256 cellar: :any_skip_relocation, ventura:        "8b988c62d7ee7a92b069e2c21aa1bfb9288432a4f9b035f2e6bd2ba3746d6407"
    sha256 cellar: :any_skip_relocation, monterey:       "8b988c62d7ee7a92b069e2c21aa1bfb9288432a4f9b035f2e6bd2ba3746d6407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c4feb7820e994a3937df3b0b7625108a03d0d6fad0828906b51e9af10efd97"
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
