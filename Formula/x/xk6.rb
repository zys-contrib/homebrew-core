class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "623e20fc5de3b5458e32be1d8b10d4e6960ad42b8d24a79465d451927fd24e43"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e44e43ef8e666f78a090414ce149ab47500c3504072f3f3bc45e7b36b6724aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e44e43ef8e666f78a090414ce149ab47500c3504072f3f3bc45e7b36b6724aad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e44e43ef8e666f78a090414ce149ab47500c3504072f3f3bc45e7b36b6724aad"
    sha256 cellar: :any_skip_relocation, sonoma:        "95dd08f6f5f7a7218ea88b9782f1efb79e32a10e72372ca1f1d738cab303667d"
    sha256 cellar: :any_skip_relocation, ventura:       "95dd08f6f5f7a7218ea88b9782f1efb79e32a10e72372ca1f1d738cab303667d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8b37426c67120565c1af227d97af5cab7c6e75a794bb56fa06881ff529611e9"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xk6"
  end

  test do
    str_build = shell_output("#{bin}/xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end
