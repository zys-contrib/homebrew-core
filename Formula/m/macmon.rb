class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "68fe17e534846e94d43539eba9ef55aa7ad0887ae2d805c1029a639e476b53e0"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # cannot be functionally tested on CI as it lacks of system profile for processor
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
  end
end
