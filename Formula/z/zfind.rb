class Zfind < Formula
  desc "Search for files (even inside tar/zip/7z/rar) using a SQL-WHERE filter"
  homepage "https://github.com/laktak/zfind"
  url "https://github.com/laktak/zfind/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e2fa544ed7ac18db29a87fb5ef96a31d28830c627e0ee755f7ee60ac87cea4c8"
  license "MIT"
  head "https://github.com/laktak/zfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbba428c78a2f37dc97e012dd00ea7d261dffe2746153f66d0948c0740ac62b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba0a02433afbb6600903135861c319c818297d0151f1a166458133bf68e4e5ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4a58ebe6a4cff507b30186636ddf0f10c33f435668a1b2d702b3dd02aa989b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "398147cca8a2f3b3f21f8d60fc60a18bc110c0de6ce1a9e5dffaa80a3ef0b087"
    sha256 cellar: :any_skip_relocation, ventura:        "97ddbac16daaa6d29bf19cdc12999941feb0014c50436ca418067d84856663f2"
    sha256 cellar: :any_skip_relocation, monterey:       "86aba4c762cdebaaba959f8a6b071b3133be83777ef5e222adf79efa03fd5f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0f628136a165952788beb4146c641d186954d4f9679a57005157383845a588"
  end

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
