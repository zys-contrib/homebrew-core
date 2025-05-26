class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https://github.com/curl/wcurl"
  url "https://github.com/curl/wcurl/archive/refs/tags/v2025.05.26.tar.gz"
  sha256 "a745475f3511090685c4d000a10f4155147b75a8c7781764612a7e8f67bb6d82"
  license "curl"
  head "https://github.com/curl/wcurl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00a0a131620bd6dfe94fa8df1179ff0b982cab055d30546c37c0cd16e3d23913"
  end

  depends_on "curl"

  def install
    inreplace "wcurl", "CMD=\"curl \"", "CMD=\"#{Formula["curl"].opt_bin}/curl\""
    bin.install "wcurl"
    man1.install "wcurl.1"
  end

  test do
    assert_match version.to_s, shell_output(bin/"wcurl --version")

    system bin/"wcurl", "https://github.com/curl/wcurl/blob/main/wcurl.md"
    assert_path_exists testpath/"wcurl.md"
  end
end
