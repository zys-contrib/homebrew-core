class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.4.1.tar.gz"
  sha256 "d5851fcec2db785e62954c8bc5bbdc67c6c08741023152b9cd31d49a38f1dc90"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83503cbcd0857684e42a5998b1831d494b687ab8f92561a39e3bcbbccee9ebdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2cf2bdbfe20db5f0d691e770b403fab4b50c9b98faf3c4c8bdb08950bc70e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "742a3c9d2f7b42b8296092909a534158c78a0f6270ffe3d0f2ff857782eacdcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4e6a89d87564684c78114e0f7616edfe934786e9cbfc9c6c632a8f9e99a0324"
    sha256 cellar: :any_skip_relocation, ventura:       "3a55ea1846907619ddd487783dba252176a9db8671af3111db9a713e5d736cad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9366933e34adb49dfee181350ebf9be75def6014f0790dcb206310b81bf5be98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e32ed3aec2db746c9108960164a4a6524dfc18236c491dce2836b5fc5c4f9c"
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
