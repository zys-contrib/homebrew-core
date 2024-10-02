class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.17.13",
      revision: "d9f563ce35e73c3da41e744ba1a35611f363591d"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c0ce950450d44babfb40ad1b0d471131ed196d4e27b81c43ff0779489af5eea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133a2db930de3f383428dc2dd29e87596a1340f28bffc5b071fac6234cc3ad40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74b325623b5597d7b259d451b814c68f08eed0a6bfb06b238e589a5f95a5e7c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "625239e3f8fe709becebb114a795ec0bd6bb91ea58313e65c8555c705ec471b4"
    sha256 cellar: :any_skip_relocation, ventura:       "386f3de296db60cd7aaa1ef391c1b2cc3841242db1719579cf2b82c11350f954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eead4287239f1c272ca49f71a28a75fecad1332658051126bdb330e9f0053972"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
