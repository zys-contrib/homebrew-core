class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.21.1.tar.gz"
  sha256 "7ccf8e94d44e8ed3048f713274cacf14e1a8eb7fa36af607fa9ab08430c70769"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628a34799de07ce3180c8b215629a5e993af0e86afcbd86af0dc0130334e36a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d03001aaae2728e3696f3568baafc36bc3f12a66dd80b8a39d97d538efa27f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd25dbe8424ff8e219d9e290eb8e4538762c64dbfac6754c021312a9da4e87a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "62bcd03bd152d69a9996c4fa882f3b450264f654f74c3b9ba65c24a30f652f56"
    sha256 cellar: :any_skip_relocation, ventura:       "35707aae7413aa30ef8a9f79408f2e1d0f779a8463030fcd5bb0e4e9613974ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99617a8659e382415e12b2d4b30f76737e1ac400125437696678468a6c9564d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af678309cc0397e3a315d11afc880b39ec28d328b34d7e3c2b3b71b8ce90a00"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
