class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "9de1aac07d58ad30cfeca4c358708cffa3fb38dfe98ce13abd984a4fd5e3b22a"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64d2f1ef864695931e8d9f44ae0d486259329087425d6648d4127e19f81c87f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff3081034d9a2b5397afb625ea8aac18f21cf36012cf021a850db4f21a16df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5047b12f94d3400ed956fe77f1a759f2a5ccb03dae039e6a6b21aafd4584d6d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfc6e9bd252b336332d7fc3c3706224f509dfebeba3a4b697549e0b763d4fa14"
    sha256 cellar: :any_skip_relocation, ventura:       "62e8f26e41d0bb70a5d74c61780f175bb47cedf73d4b687d2c2cc56f8de2a18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d373e4df05379edace9a1b9c8eb17b562b55a098bcd034afbfa458d4ce7f1d6f"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
