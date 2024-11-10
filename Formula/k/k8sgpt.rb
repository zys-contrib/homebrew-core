class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.45.tar.gz"
  sha256 "8b471fba0b3a4529edee80db21cbbfd13caf1640b5b2aa535b28376233332393"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9120e2171939e69077fca7424130bd35ef8b0e289526f4ba116a511134b2a00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa1abfee1cca187c530d9799794d2b75e75913130fa212c3c6328a3f0e3db5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b22db227cd3bf4b2db43b42d4f775172d76be7d939cfe647464fac6c2c5ecb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "03a701fd1a026d7e6cf0d79c675bf14f0ee4b1a53e02c4a7fb773802705662de"
    sha256 cellar: :any_skip_relocation, ventura:       "32226a4a6e801dd17d74c69ecbafe4476fe9a61dee6ea60ec9bd7eb875895714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3f09664b19cf796422aeb7a5c72f0ab0143c31d3708b4dd8b9a86579f15a80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
