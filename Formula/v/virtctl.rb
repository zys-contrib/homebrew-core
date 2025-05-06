class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "003b8aaf5d87f92f7a49bb51e3a1ee44a7fbe7aca10fd9b165bc8b79fe91f52e"
  license "Apache-2.0"
  head "https://github.com/kubevirt/kubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb3c2bc4d91b38c2dcca3afd30df6bf0986691e2aa616e56926cb862e462377b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3c2bc4d91b38c2dcca3afd30df6bf0986691e2aa616e56926cb862e462377b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb3c2bc4d91b38c2dcca3afd30df6bf0986691e2aa616e56926cb862e462377b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c252788f12e9efc5a32c678e7e556c247549823600d6fed447f4082e47f9f9e"
    sha256 cellar: :any_skip_relocation, ventura:       "5c252788f12e9efc5a32c678e7e556c247549823600d6fed447f4082e47f9f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1df0e7ecff25621fd7ef4996d81dd7f7e7950096f47e7646c0054d3b9efae6aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
