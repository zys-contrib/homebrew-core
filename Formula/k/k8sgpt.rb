class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d7896ac976c7f04c93e5c77bccc594bf618e3328a91d07302170c5c776fb09e2"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f47a4f698d7d8dbf3ebd668fb26c51bab036a595b227cd351d4eb26ce3e97a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5dbe018be3a0cca5b2bf701ae0f12d2818a723da9595c2f2aa3f7c10cc2e9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4058c3b03bcfd99f7ed21d413356386e66daf0798bd63016ce7fa17573676147"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a6a7f12fedb0bc0fb2c65bf04dc4a46d53225369668a9a19d120134bb9e8196"
    sha256 cellar: :any_skip_relocation, ventura:       "2254885bc9764104fb9d5b617cfd526e215fe6f019b93830d8a09e1cacad4247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da8f7c97cc51c51c2b2ca8471048a0dab48af8af7048d1c9633c814b2ad1a60"
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
