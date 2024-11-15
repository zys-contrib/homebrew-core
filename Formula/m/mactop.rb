class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https://github.com/context-labs/mactop"
  url "https://github.com/context-labs/mactop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a2eb799fc216ef7560897b2b03634143c52cd919482333a340350a0c56fbcc65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3539acc9c56b4d8b4e065eec76bda27a2fe0d7350f580da3a86c6480df00307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a1c8476826517ef5c84753c47f154bb9dc8baa37c5f98d9c22e36d9168b64b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de67519131c8454a42d12d3d612995958e6020b45e7e859d6b0f1e14de8abdb9"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
