class OpenapiTui < Formula
  desc "TUI to list, browse and run APIs defined with openapi spec"
  homepage "https://github.com/zaghaghi/openapi-tui"
  url "https://github.com/zaghaghi/openapi-tui/archive/refs/tags/0.10.1.tar.gz"
  sha256 "fcabd971c5587394e84c1b0c30dace7db0ae950af3d76b0ea47331b19eeb8590"
  license "MIT"
  head "https://github.com/zaghaghi/openapi-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "572f836b188722339bd195d37fa72edf7049abf5d54761750e4a7210edd1c824"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc08516061e7a429cf34c39f9fe08c64a2bf068bbe5f0118a202e281c4722c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3e737a05a7212e5864dbf112639759801c440f1440c5f7433ae06048908c021"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d79e3c693d2870f3d3deb567e32f5cfecf556cbfd49978816f9ac75155997a"
    sha256 cellar: :any_skip_relocation, ventura:       "dec93d0f7e9f87101f3ce77e5ef493e9b7fb27cfc746ff7a6bd6d97485466748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a508729f861145564f28d53675d23c1a2f4157fbbd0cc83caa7b49be28b23176"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi-tui --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    openapi_url = "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"openapi-tui", "--input", openapi_url, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "APIs", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
