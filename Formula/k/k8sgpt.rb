class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.48.tar.gz"
  sha256 "136aea5b15d3d3089ae3e2306cd5aa306e29f4fa95db99074ea561d74808b034"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ec9ccdbff82bf2761f13756c0daafe0e12bd4cda5750624451ec413404ff232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588c268d57554313fe57ca026da02df45799fcf3b187aeb46adbff24692275e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30c9a50027b0f1293a6f10100aea3a796876606db09add08a1a45806d2966fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "defece94ff1e0596d1c1253ca5f35295c5517a0d48a683caef8ab32e1b0592d1"
    sha256 cellar: :any_skip_relocation, ventura:       "1294218977e4c850a1ec300cb3a402c6c0f64c5b3e1d2ce43952e719ebec33c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89d7692c563a34b3c60a3e0e809b62da76d5a5e42f51f36db858988d281defb3"
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
