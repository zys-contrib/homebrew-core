class Zfind < Formula
  desc "Search for files (even inside tar/zip/7z/rar) using a SQL-WHERE filter"
  homepage "https://github.com/laktak/zfind"
  url "https://github.com/laktak/zfind/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e2fa544ed7ac18db29a87fb5ef96a31d28830c627e0ee755f7ee60ac87cea4c8"
  license "MIT"
  head "https://github.com/laktak/zfind.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zfind"
  end

  test do
    output = shell_output("#{bin}/zfind --csv")
    assert_match "name,path,container,size,date,time,type,archive", output

    assert_match version.to_s, shell_output("#{bin}/zfind --version")
  end
end
