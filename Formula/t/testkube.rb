class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.45.tar.gz"
  sha256 "18a4de5827125e4fd7fec2b7687deb09cd6337b697a70b916df9e0163bfa5da3"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d393beb79ea6a19c87dbb84f75f42729188869e2eccde13372119d1357432db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d393beb79ea6a19c87dbb84f75f42729188869e2eccde13372119d1357432db2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d393beb79ea6a19c87dbb84f75f42729188869e2eccde13372119d1357432db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc7edeb518a9a99a67f06a2288f873acefa286730c400e8ff4ccb390f9e248f"
    sha256 cellar: :any_skip_relocation, ventura:       "abc7edeb518a9a99a67f06a2288f873acefa286730c400e8ff4ccb390f9e248f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b50e753a08633a750f0216098a09fca5a17f143039a94cd9c1865284d303f9"
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
