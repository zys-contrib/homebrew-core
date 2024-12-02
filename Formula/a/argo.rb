class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.6.2",
      revision: "741ab0ef7b6432925e49882cb4294adccf5912ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e33b90a7c9a6d6868fa4f2784d0bee0026eada90fea4110796f55983ded1b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "147d27aabad275050dbbbac0c6f7195ae970709dbdaf3eb5d588da49d2035674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b6db90e7ff2084b7873a038c6592398c7c2eadb5ef29658aeb7b4eca55d3188"
    sha256 cellar: :any_skip_relocation, sonoma:        "2acf5ab660d0168b5d1c03a07ca4e022cf398b3c6fa2b31666db0abac1ff936e"
    sha256 cellar: :any_skip_relocation, ventura:       "7a97351f99b8ac54c2cdfbe7357a4fc4f58142082d3ab70bb36017ed8462903f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4bf17844c48f2a2561e6e4ff839977375867d08bc7ae32411b5d2de5b46d7e9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo", "-j1"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
