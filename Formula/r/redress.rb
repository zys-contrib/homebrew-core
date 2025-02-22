class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "328ee8a90ce147e8e438d38004c3546dad6c2bdf4c2846a0ed3657617d35e1eb"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d668454728863f3bb8a88ea3e6cd2469c68844315f75336a01dac55638de9a31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d668454728863f3bb8a88ea3e6cd2469c68844315f75336a01dac55638de9a31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d668454728863f3bb8a88ea3e6cd2469c68844315f75336a01dac55638de9a31"
    sha256 cellar: :any_skip_relocation, sonoma:        "662d1a3610ebd91556f660c5625e25fc26b0f2df0a5797d2081923df46d29228"
    sha256 cellar: :any_skip_relocation, ventura:       "662d1a3610ebd91556f660c5625e25fc26b0f2df0a5797d2081923df46d29228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92dbe35cb25c767489267598473453dbb31b2da793f932a9caaeac37dd25221"
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
