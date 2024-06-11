class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.62.tar.gz"
  sha256 "cc2fe79b237595ca145a1acf9ec61f93c21c9dd2c929409a67e0bb8f7c11c7ac"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68f904437815c8c036c18866ba584ac0b52ef82daf88b98c8157a78509bfade6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ad5b07ecda5d7de7bc8a19b85c404d1a3d220e50e81c43955af796165ee7e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5fc8071dc26ce3342ca7c88b9b056a726a27e79ef06e8ad775c386c0233748e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b439ff4464c98c6f9cd84e6ea99dcc812203e1ebfb3ac98ec5286d479969e74d"
    sha256 cellar: :any_skip_relocation, ventura:        "16b0c63632ea4489365f20cc4c7b1c057046655f2731f048745ccac6b8f52c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "a0ad17c8697c22a583ef80e43d6e0bb2e2394de0916f70e3973de48ecc9098fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9b8a0f88fdf8c728af295966814cd5cbc03bd485e9bc9eefc29e506bc5ccdd"
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
