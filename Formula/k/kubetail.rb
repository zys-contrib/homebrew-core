class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.4.0.tar.gz"
  sha256 "cffa084fa61bf2a6ca2112e3482002ce907be7952a86254d8babd5032d3e99b3"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "278714e8ddaacbfe177d5999a5d01880477db71a1f671aead0bea0a211a05cf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c59d4e895526f7f207d3edcb8368230681d1d51daedab696a1e1f7c86e6b591"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4db176189370341ca9d72c8e7cf4a29aedad991acb3f4d437f9f0dc7f0d0b91e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9281e10f6845d495442822503dcdf6683c3ff9f3f70d82a2cc70c29e07666929"
    sha256 cellar: :any_skip_relocation, ventura:       "25c10ae448fad695916826e0e050c2ca6714d05a25525b3a56cd4ff975ecc0ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df95ae962d22abda56b72422620130112c1a629274c0a31458c6681b1f3bf392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2772130eb2dbcddc40b19984a9040ef53452daef4ad981ce4851a2bc28c048ae"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
