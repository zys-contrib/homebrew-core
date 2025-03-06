class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.109.tar.gz"
  sha256 "6f67d1f602f1121c6181863fdb319eb33be8c431e5ddfc5a5c474c52d204b6c7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22842fbd7fb5627f091b5e1d892376ac4ec0df68b17979f8323adb4ac937acfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22842fbd7fb5627f091b5e1d892376ac4ec0df68b17979f8323adb4ac937acfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22842fbd7fb5627f091b5e1d892376ac4ec0df68b17979f8323adb4ac937acfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f09ef47577206615de06ceb0c2085b1c16c20e547c478ac838575d9993bcbbd"
    sha256 cellar: :any_skip_relocation, ventura:       "8f09ef47577206615de06ceb0c2085b1c16c20e547c478ac838575d9993bcbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440e5c35a3f63ba3a8c60622c5e64ccdd94b8cf6c5640706528e741b53b06dbd"
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
