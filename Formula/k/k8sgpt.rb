class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "abf246ed586572a1759de8727abdbff2ebfb5c5adb265114f995007f8d8e5e0f"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c18a35c79df926c39ce92c8522bfad7ff8f6dbe55a8ef50d9c493f30c8808d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "267d97c3c7602e9329af41fed72c8499d01f5477295952577ca735f493c1d749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e6248da10a5eb6224ec39da11fd62240ccb9f784076ca0280a38e31ee5c69aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e3b26d33841285787757c5c1d3412ea0139a899231e4fb63c9673e4c61587b"
    sha256 cellar: :any_skip_relocation, ventura:       "936001127939b16f10e9c51832f749788450dbe7151a575b1706a9ea0d0da061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac1fc62a20c016dd2f25318d79cd4ce2c158d6edccb9e6f6c1c24c255adf8fc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
