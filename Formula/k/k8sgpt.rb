class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "e376c2f04ef07d77f6be88ba05076b82cb11e2329d5121d2766e39635dd3d5a4"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c32e1148d4f45a731d40dc8de3d03f51cb92a88f2720d2cffa0355d193338f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e78815dfd76f890634395fb72c714fd1eadf11da15247e698a00e4b4bef7e2d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35c63d2389fbe87c7d138aceef32aea7c9ccec287eaa166f68ec817531b5644b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cce835a8e13f5af6b9cbdc53833be1a74ca2e709a8843a2a51391d9316ebd85"
    sha256 cellar: :any_skip_relocation, ventura:       "dbcb49ef5e0ce16828339dc07143b36e9aa1df18153815545717fbad0872e218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6391cd45fb607e587d71b2aadef237bd1a6796b6e274f93993da5c2099fa4cb0"
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
