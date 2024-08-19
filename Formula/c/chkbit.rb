class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "539363bcb5971fbe55104aae5e85a882699705068bf62b0c149fd695e27d9588"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eca43da47371875365f790d768a4c659af462c1aa0b12fb5ad462dd45a20e38a"
    sha256 cellar: :any,                 arm64_ventura:  "6266986c2a346550d5112318e3d3d174a531943e87640923f7a86286ad310dc8"
    sha256 cellar: :any,                 arm64_monterey: "ea5749e4aa1f96805a69a0f0b0ceef26c49ba5894fce7aff8af1665997b85720"
    sha256 cellar: :any,                 sonoma:         "9fbcdc42034ae0d906ca14794a07f0c2e37278046c5fdcfcc349043340a6e550"
    sha256 cellar: :any,                 ventura:        "81ce5dc4ffcc1812df1101ab0c697c7eb60548ae9d4e42844267edabd2af25cc"
    sha256 cellar: :any,                 monterey:       "73327c0a66310ba120b57391fc5e93601dea45fcd601712d0c3f2ca1f9f77e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5eb0a6a4d5101e55ce44c31bb6369b34c937723e844befd18c6271459d4f00"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit --version").chomp

    (testpath/"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin/"chkbit", "-u", testpath
    assert_predicate testpath/".chkbit", :exist?
  end
end
