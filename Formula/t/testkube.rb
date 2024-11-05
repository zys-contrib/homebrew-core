class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.57.tar.gz"
  sha256 "5723ba6a944952ae9a28e03f08212633bf3211e7af87d75b8169bb4661328d08"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcb98fac11e313b22e3ef5533f2ae94e533dc77aadeef4a9240937730bdd9bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcb98fac11e313b22e3ef5533f2ae94e533dc77aadeef4a9240937730bdd9bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcb98fac11e313b22e3ef5533f2ae94e533dc77aadeef4a9240937730bdd9bdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "89f49f01204e87b6905c87580e5e93504eaf3f865852cb207df918f6cffb7af5"
    sha256 cellar: :any_skip_relocation, ventura:       "89f49f01204e87b6905c87580e5e93504eaf3f865852cb207df918f6cffb7af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0993990e6bcd25fe86d3ff754132fd2fe9f50ce38a22932f6a9ff7033e455f81"
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
