class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "d9e2378c07be60ba42eb1a87e5b5c9eac9f0078b3643757a8d560e2690327c36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae3ababd32a665ae0344d800e70dcaf9c0c45646526e853e9ecab870547ef01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fae3ababd32a665ae0344d800e70dcaf9c0c45646526e853e9ecab870547ef01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fae3ababd32a665ae0344d800e70dcaf9c0c45646526e853e9ecab870547ef01"
    sha256 cellar: :any_skip_relocation, sonoma:        "18fa02e7cd269e415859dad919854aab2870d1ef02b43cc6dd325c01a18dba45"
    sha256 cellar: :any_skip_relocation, ventura:       "18fa02e7cd269e415859dad919854aab2870d1ef02b43cc6dd325c01a18dba45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfebf1c712b133eabc7d95fec90f16b22a439aa6533343fab525d8fa90d84b4f"
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
