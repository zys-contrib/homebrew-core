class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.12.tar.xz"
  sha256 "c165077b150d175845199b5763643d1630e9afe9d02fa58be227a1ef00bf4abc"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33baa0f106ac23d8beefe7c58bb5508e2e474be4de5f255e35ec75376f1ff18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f33baa0f106ac23d8beefe7c58bb5508e2e474be4de5f255e35ec75376f1ff18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f33baa0f106ac23d8beefe7c58bb5508e2e474be4de5f255e35ec75376f1ff18"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c67b6e30e3cc8a936b12823b62c2e231fce1ddaed9952e02aa60b2b4c3d0159"
    sha256 cellar: :any_skip_relocation, ventura:       "7c67b6e30e3cc8a936b12823b62c2e231fce1ddaed9952e02aa60b2b4c3d0159"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85aea278244e27e0c22e5f5b7ea8d75f2aed82b336e6d43aa1202c1cf47c3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec446b12f0dd3117900bf9ba57dfffc4f427cb4d4aa9d25c4c8a06070062d695"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
