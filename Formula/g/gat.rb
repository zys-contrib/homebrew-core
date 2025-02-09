class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "4acdc6275ec659c362f2fa9f7d1a97654f6ce6238ba050260687a5182e4e2152"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6d60b4eac2e55d5ce16a0ea8675610b688db3902b07af1f002eb76260caa73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6d60b4eac2e55d5ce16a0ea8675610b688db3902b07af1f002eb76260caa73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be6d60b4eac2e55d5ce16a0ea8675610b688db3902b07af1f002eb76260caa73"
    sha256 cellar: :any_skip_relocation, sonoma:        "acddfcbd7394510ca5c3c7ca69b71b9b0f5826943a758c4ea139824e3bed910f"
    sha256 cellar: :any_skip_relocation, ventura:       "acddfcbd7394510ca5c3c7ca69b71b9b0f5826943a758c4ea139824e3bed910f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c12cdb38842f431cbe35c2a627841d5b669ac38eba01aa62114b5cae9d0314f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
