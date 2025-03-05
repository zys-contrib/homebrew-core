class Mox < Formula
  desc "Modern full-featured open source secure mail server"
  homepage "https://www.xmox.nl"
  url "https://github.com/mjl-/mox/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "77d6424e6b4cdafdb5a19ea79adeef982c426c58804671a6a0167edda883d50c"
  license "MIT"

  depends_on "go" => :build

  # Allow setting the version during buildtime
  patch do
    url "https://raw.githubusercontent.com/NixOS/nixpkgs/1ac75001649e3822e9caffaad85d7f1db76e9482/pkgs/by-name/mo/mox/version.patch"
    sha256 "5c35e348e27a235fad80f6a8f68c89fb37d95c9152360619795f2fdd5dc7403f"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/mjl-/mox/moxvar.Version=#{version}
      -X github.com/mjl-/mox/moxvar.VersionBare=#{version}
      -X main.changelogURL=none
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    user = ENV["USER"]
    system bin/"mox", "quickstart", "-skipdial", "email@example.com", user
    assert_path_exists testpath/"config"
    assert_path_exists testpath/"config/mox.conf"

    assert_match "config OK", shell_output("#{bin}/mox config test")

    assert_match version.to_s, shell_output("#{bin}/mox version")
  end
end
