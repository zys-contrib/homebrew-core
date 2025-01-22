class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.88.tar.gz"
  sha256 "d391ec29b939ec0e5f8add74b7bac2afa523316813756f5068c86549f072c835"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c0e6d33dd49a3d984b2f9b63a8ea25cfe7076bc04924ee616cc621dbf2152db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c0e6d33dd49a3d984b2f9b63a8ea25cfe7076bc04924ee616cc621dbf2152db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c0e6d33dd49a3d984b2f9b63a8ea25cfe7076bc04924ee616cc621dbf2152db"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f19218a2cfa2de3e2e7c30ee4ad1d37791a66ee59a91cc9c6dd888df30a267"
    sha256 cellar: :any_skip_relocation, ventura:       "05f19218a2cfa2de3e2e7c30ee4ad1d37791a66ee59a91cc9c6dd888df30a267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b572797ac375975aeae0eb850b37aad73831c491482a72fd60e96df5df8f464"
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
