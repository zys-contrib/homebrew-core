class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https://github.com/curl/wcurl"
  url "https://github.com/curl/wcurl/archive/refs/tags/v2025.02.24.tar.gz"
  sha256 "640319b7a3dfd693a4a513ae603539b9e0632a706ed75f969765f5341f1a14c7"
  license "curl"
  head "https://github.com/curl/wcurl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01f3be279345c0d59243531442733acc39245a210d3476a76a9dbf29f67bf533"
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
    assert_path_exists testpath/"wcurl.1"
  end
end
