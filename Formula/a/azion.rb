class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.34.1.tar.gz"
  sha256 "05aeaaae348ff53846ebbf62f379353c2f240450ae3a174eaf3760f2cd0e6b8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "894d68927cf3a27f31163ac99204b31c2e9731c0191662c78aa409bb91518e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1380f1d31a40443abd8d2675d3275a97af8ffbf27e6772f7a022955a330d066"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a86d7df451c644c28573affdd381b7f6ce251bd900755ace7ad6f42e04a9351d"
    sha256 cellar: :any_skip_relocation, sonoma:         "98ed7543742720203f0073e8ab47009054e25833b5a8187251fbe7799a5d83e2"
    sha256 cellar: :any_skip_relocation, ventura:        "5d38bfdde85928779998457c0028ad9598d582442a9457de1f6540ddb42c7d81"
    sha256 cellar: :any_skip_relocation, monterey:       "c2e44b689d7c803ea5392579a22d83dbe68088ee08d11b4b18c094e2e17b4c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93da6d51525d3b27b6525bea3fd51287242ef5a937b575a1c07dd43b83e6f6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
