class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "5113cee9128c64cecfe6fa6896e8373a30d14c7f2bcb3614a575fbd024bb5681"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e898e586d76b51caf878ef3535872272f7d4b00a05a401928010cbcdc2aabf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e898e586d76b51caf878ef3535872272f7d4b00a05a401928010cbcdc2aabf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08e898e586d76b51caf878ef3535872272f7d4b00a05a401928010cbcdc2aabf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d279a47b671fe5e1f3c953b91f43bbb6d7d9cbb6cb925b3aed98a4c7e9667e48"
    sha256 cellar: :any_skip_relocation, ventura:       "d279a47b671fe5e1f3c953b91f43bbb6d7d9cbb6cb925b3aed98a4c7e9667e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd397dfe5f69be9ce52e3e93cac6194a112b69e990c5a057ee963a5a828210fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", "completion")
  end

  test do
    assert_match "Version:\t v#{version}", shell_output(bin/"jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output(bin/"jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
