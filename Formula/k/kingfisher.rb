class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "749c5532ee49d9a358e8be9f925abda5589002398fec664bbd54db029af13e88"
  license "Apache-2.0"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kingfisher --version")

    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
