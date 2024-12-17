class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.79.tar.gz"
  sha256 "667af023b7d34e593b86a01588de9fcc781f229b65f140584e234fbf7f0ea0c6"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3f84b05fe7cb498881ab2c8f8834a2e49430bab7cd23e0dc86c5ed1d811129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3f84b05fe7cb498881ab2c8f8834a2e49430bab7cd23e0dc86c5ed1d811129"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a3f84b05fe7cb498881ab2c8f8834a2e49430bab7cd23e0dc86c5ed1d811129"
    sha256 cellar: :any_skip_relocation, sonoma:        "6912900d5d7599ea19d8154f9e30453683f4cfde93472e50d4fd09d9bd739625"
    sha256 cellar: :any_skip_relocation, ventura:       "6912900d5d7599ea19d8154f9e30453683f4cfde93472e50d4fd09d9bd739625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395dbcf20528eea90ee7ba16fa004a0453f28b13861840bff430ba35cd2297b0"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion", base_name: "kubectl-testkube")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
