class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.1.13.tar.gz"
  sha256 "350992cb2fe4a69c0caddcade67be20462b21b4078dae00750e8da1774926d60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "359daaba693d6bfa76c073e9f329fdd360ef59fa00d87cc1dd7e50c1b6a3d1a2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"

  def install
    system "make", "install", "PREFIX=#{prefix}", "LIBEXECDIR=#{libexec}"
  end

  test do
    assert_match "conmon: Container ID not provided. Use --cid", shell_output("#{bin}/conmon 2>&1", 1)
  end
end
