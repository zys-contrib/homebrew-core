class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "a4bac484569d1482e26ef9aa43b9bab1ef66621f6ae938f9e435de7148bccace"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920e2b6699f0e32d1ed04e449465ddf5f2d0b48b422e329719b6f0d0606a82f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85d0c121c206ef3617dad359c037652fe8735b7f45fd72594430b154afe71723"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a344a6bbdedc5fa971a66142832a736fd44b9d836cf5fde854eaaf96a736c4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca3d90f50afaa5865749ab82b2182c35b1b9292ada2d8fa56aa28a01dfb8d537"
    sha256 cellar: :any_skip_relocation, ventura:       "5497f87d2c8a51ba584dbcd00e11d00e960bbb594d8d820c20511d1fd0fa1cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0729a51436833e0fc5f6d9c1d7566d661c70bd7d1a602f4a1627a6e6a3293915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e079ef61b59011b4387dcaf1c89fd26ec08d82ecaf9fedc61c022a6f92aaaf24"
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
