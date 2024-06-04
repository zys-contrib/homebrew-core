class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.181.0",
      revision: "48a8e87dede5c400bf9cdd204c7a9ded0b279ae7"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ceaadf1b153aa79522cffc40627fc1eda080cf69144c81aff593862ec4cef2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9abeae22bd235d39ff651773a4e41c0d5f33d65a923d314f96b843ed00f59243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc76a09e0201bae07eea7ad5f80ec481df82456a81e69fc83a1e0003a09bf019"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f67feaad4ddb8cb22baa6dad46e781c963454bc182c29b829fea14abc44309a"
    sha256 cellar: :any_skip_relocation, ventura:        "fec4246b4c3987660f91ab1d200ec3213ae95021b192aa5c5b0ddc50b4127a41"
    sha256 cellar: :any_skip_relocation, monterey:       "0c30e261dcda3a43142ac6cf201e399792da1ee0408a9c27df5afd21db06e474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f18a90313a7afd4c50baf206cbffeb7439953c11260784b4b0fd6d8ceb0d9f7"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
