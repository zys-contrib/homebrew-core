class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "1c70dc57cba0629f9600534b63134ebeab42a3f43f1d2d166605bfb25c0545d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "665c3f1ac6693f160ef39133d57581edd09da500c20d289a0eea999047860649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "665c3f1ac6693f160ef39133d57581edd09da500c20d289a0eea999047860649"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665c3f1ac6693f160ef39133d57581edd09da500c20d289a0eea999047860649"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665c3f1ac6693f160ef39133d57581edd09da500c20d289a0eea999047860649"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9910e2217a37e46971e83f6539b3434d1a6da07f263a8bf03e7d5ba2e4fabb4"
    sha256 cellar: :any_skip_relocation, ventura:        "c9910e2217a37e46971e83f6539b3434d1a6da07f263a8bf03e7d5ba2e4fabb4"
    sha256 cellar: :any_skip_relocation, monterey:       "c9910e2217a37e46971e83f6539b3434d1a6da07f263a8bf03e7d5ba2e4fabb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566af6ffd5e4710b5b987631f0c56034a4202d8783511e32d742d7ea02947c89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
