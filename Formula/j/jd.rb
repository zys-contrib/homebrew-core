class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "376cff4dc5db6ee6c7cb4c9cfa77ede13eddb679f978caff5caa944c16c72b6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0baf5de150f1da03dc98acffa7824c38caff444c0c554ff7fc2494d2ef0265a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0baf5de150f1da03dc98acffa7824c38caff444c0c554ff7fc2494d2ef0265a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0baf5de150f1da03dc98acffa7824c38caff444c0c554ff7fc2494d2ef0265a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4651c19240462e0c7db62791b348e0b1a951c5ac7b3b6a4a74634997df227c"
    sha256 cellar: :any_skip_relocation, ventura:       "8f4651c19240462e0c7db62791b348e0b1a951c5ac7b3b6a4a74634997df227c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196ec37dbd6b46e247d1476cf104e9568d7ac6e2ea254937e75e357c6ab9a8ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}/jd a.json b.json", 1)
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
