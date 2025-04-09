class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "b5acb52f9c4d395d815ce61bccb835ee87e971ad72192c070e8ed565ae8fcb98"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb9fef5a58cd485a651539842623e408417908c32343237ee0e283b3c82fbb7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345398ce7f0f1671243f83c1996f69484f7cced7aae5c830bd2bcd067a6547c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c15cf52b068e5881b799d6bc5c5584835b06f9b0841a837e22e896111a6fb455"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf84042f95970a2698c636dc7ae9cabaf44d3ea048771048266878b96786043a"
    sha256 cellar: :any_skip_relocation, ventura:       "38d6381731879ebb43109bbadaaa25e925a1f5b814e723df17f160b07d45e406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004539cf713f3c3c6a8f9b8f4b8f3347bf6abeabd169de5b7c72e37fab3126ba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
