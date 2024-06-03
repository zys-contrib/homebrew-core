class Svls < Formula
  desc "SystemVerilog language server"
  homepage "https://github.com/dalance/svls"
  url "https://github.com/dalance/svls/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "ef6fde93d2434835e33fc75dd5234e993e75bdd446570f2da6d6524d61f19777"
  license "MIT"
  head "https://github.com/dalance/svls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7d437f689fadc95af269978f91bf93574b980602d990d19033075147f2286b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a086c8d016221ca6034b8afee9bf5213b889d216fb41b9c44e78307c081f873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf4a0765378136f5c0675674121f6d943f0edb5d06b4f75123a4ac704c922d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba98425a17a028485cd655fd671bfb667cbdac4a858a2e86ddd06dc7eb2a23ff"
    sha256 cellar: :any_skip_relocation, ventura:        "7690fac7fc6b1d5ab9fd509c297b3111ca43d95e4cd471d3ede9d71208fc9002"
    sha256 cellar: :any_skip_relocation, monterey:       "6559cde47dc65ff1eaa548eb575d737652a823b380de2bf183df496c0fd1e45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687839386e0751cf5586c7d1a106b7eee2b03d37a8f94accd418ccb48acda919"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = /^Content-Length: \d+\s*$/
    assert_match output, pipe_output(bin/"svls", "\r\n")
  end
end
