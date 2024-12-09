class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https://github.com/curl/wcurl"
  url "https://github.com/curl/wcurl/archive/refs/tags/v2024.12.08.tar.gz"
  sha256 "9c0615b2c5d6b21da79ff559e75452197330d18449085a18e05f4b623b144a94"
  license "curl"
  head "https://github.com/curl/wcurl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "af8adb8368a8844d3552b6b6efed89c10d4bb6b03220dab7bdc73b658422e04b"
  end

  depends_on "curl"

  def install
    inreplace "wcurl", "CMD=\"curl \"", "CMD=\"#{Formula["curl"].opt_bin}/curl\""
    bin.install "wcurl"
    man1.install "wcurl.1"
  end

  test do
    assert_match version.to_s, shell_output(bin/"wcurl --version")

    system bin/"wcurl", "https://github.com/curl/wcurl/blob/main/wcurl.1"
    assert_predicate testpath/"wcurl.1", :exist?
  end
end
