class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.19.tar.gz"
  sha256 "b7c4076b83f4c70cea241920b317069ae1b5cce6ce8169b6add2294f3efa6574"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1099548a6914c50c2d7deb6a3744094023e76f46c45e8b3d538307c403f6ca81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1099548a6914c50c2d7deb6a3744094023e76f46c45e8b3d538307c403f6ca81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1099548a6914c50c2d7deb6a3744094023e76f46c45e8b3d538307c403f6ca81"
    sha256 cellar: :any_skip_relocation, sonoma:        "07c0e79b1f29f12e0e5f6c048020176813a1b435cd6ec8422880941f37f97bda"
    sha256 cellar: :any_skip_relocation, ventura:       "07c0e79b1f29f12e0e5f6c048020176813a1b435cd6ec8422880941f37f97bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ea4f7c88c74f3b5e71b0933f656f33325293b2575bf4efae11bd033418a687"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end
