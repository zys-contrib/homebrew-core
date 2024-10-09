class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https://github.com/MightyMoud/sidekick"
  url "https://github.com/MightyMoud/sidekick/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "15525dcd4cd2dca9bf109b93b6ad771ca51b7a88449d0fabf43dcd8dd3ed0bd1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2b3ec898a4dc3d31021292935b605c5b9416157527e9f2891a495215e7f2767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2b3ec898a4dc3d31021292935b605c5b9416157527e9f2891a495215e7f2767"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2b3ec898a4dc3d31021292935b605c5b9416157527e9f2891a495215e7f2767"
    sha256 cellar: :any_skip_relocation, sonoma:        "5071238ce5b3835245d352ef87b62845d792872e0062cd604a13236b12fe5ca7"
    sha256 cellar: :any_skip_relocation, ventura:       "5071238ce5b3835245d352ef87b62845d792872e0062cd604a13236b12fe5ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fe09931ae7cd50e23f5f40a97273a085a842c90b3c7333d115090317fa84fcf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'github.com/mightymoud/sidekick/cmd.version=v#{version}'"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin/"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}/sidekick deploy", 1))
  end
end
