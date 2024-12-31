class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.2.1.tar.gz"
  sha256 "78bf0efd00daa9002bcdeb460f4ddaf82dde4480e63862feab0958ed9ed54963"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "215843839647c62c0da9ab1a29a528736542c9b11432d862e73d62b6cd9a7650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "215843839647c62c0da9ab1a29a528736542c9b11432d862e73d62b6cd9a7650"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "215843839647c62c0da9ab1a29a528736542c9b11432d862e73d62b6cd9a7650"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc6dc6dcff7f0e1a96c473986de5d3e57bcac25bda561748c999f3d2f9935f46"
    sha256 cellar: :any_skip_relocation, ventura:       "fc6dc6dcff7f0e1a96c473986de5d3e57bcac25bda561748c999f3d2f9935f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b455747f05d232bacff39562dec9f21b21a5a3941473a769e16e05dd4a5ac39"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
