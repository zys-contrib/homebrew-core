class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.11.2.tar.gz"
  sha256 "8a8cc2c51d3118ba8fdac1bc93bb1c25fd6fcc135415f34ce3b02fc057be2f2b"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c46c21bfc0531dd1533ab177c813469b4d63be5e340a190133c4e09155c19043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c46c21bfc0531dd1533ab177c813469b4d63be5e340a190133c4e09155c19043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c46c21bfc0531dd1533ab177c813469b4d63be5e340a190133c4e09155c19043"
    sha256 cellar: :any_skip_relocation, sonoma:        "f00ac9c9e57c101304edb3e46b78dd3b41ee7db4382b685ab7251a833d1783d9"
    sha256 cellar: :any_skip_relocation, ventura:       "f00ac9c9e57c101304edb3e46b78dd3b41ee7db4382b685ab7251a833d1783d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e592a0d6092640b0b0ef615e8a21535bac852a21203b9de1b4f18e6d35c9db8"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
