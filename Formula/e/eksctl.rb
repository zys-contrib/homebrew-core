class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.195.0",
      revision: "331eb7ed5da088cbd9065af34513d19408c795f3"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fbb49cd18162c5417ccebb0b8240b02a5d4cbab5aafda3e905d8ea352d67994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e138f09b573c16968b6eb966f2b0e02b21b9f178c509329e2101cac9922e60ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8ab4fb047855b0893f259cf7c8b73ef5e8c91facc2d4d7d107a4443b00c5612"
    sha256 cellar: :any_skip_relocation, sonoma:        "641f5fd6d5087914e2d18fec810f3a6eb8f438efd276ca316be0ffb628650914"
    sha256 cellar: :any_skip_relocation, ventura:       "31d2dfbb8df5caae6ddeab2cac1d5e8a55e11cca7fe5ada90d686b7222bfbf83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e485f88a19ca8caa76d877f0c808c9d7a2f010b33e2f08f7cd428f7a778dc95b"
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
