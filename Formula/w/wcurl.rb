class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https://samueloph.dev/blog/announcing-wcurl-a-curl-wrapper-to-download-files/"
  url "https://salsa.debian.org/debian/wcurl/-/archive/2024-07-07/wcurl-2024-07-07.tar.gz"
  sha256 "5ee1d686aeef4353cb023be341f4b34401d8c6f55039cdda5d52d47cf8db4932"
  license "curl"
  head "https://salsa.debian.org/debian/wcurl.git", branch: "main"

  depends_on "curl"

  def install
    inreplace "wcurl", "CMD=\"curl \"", "CMD=\"#{Formula["curl"].opt_bin}/curl\""
    bin.install "wcurl"
    man1.install "wcurl.1"
  end

  test do
    assert_match version.to_s, shell_output(bin/"wcurl --version")

    system bin/"wcurl", "https://salsa.debian.org/debian/wcurl/-/raw/main/wcurl.1"
    assert_predicate testpath/"wcurl.1", :exist?
  end
end
