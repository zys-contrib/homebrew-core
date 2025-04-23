class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.146.tar.gz"
  sha256 "8ce90c36c7f612697732dce0f3ec54ccb6f5dc95130438b4b08202c07935c5df"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3c3254f818dd65f05ba049250dd7eb757ed91e262c02267b83d880c8db81003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3c3254f818dd65f05ba049250dd7eb757ed91e262c02267b83d880c8db81003"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3c3254f818dd65f05ba049250dd7eb757ed91e262c02267b83d880c8db81003"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0ce577143919984a844261ac686465c5977d3a079df751f33caec158797eca0"
    sha256 cellar: :any_skip_relocation, ventura:       "a0ce577143919984a844261ac686465c5977d3a079df751f33caec158797eca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7c5ec1d5c3f6eeb822b990ad5bf2bf63587a6ff7257de5d8eeb28860e88da9"
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
