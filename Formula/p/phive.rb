class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.16.0/phive-0.16.0.phar"
  sha256 "1525f25afec4bcdc0aa8db7bb4b0063851332e916698daf90c747461642a42ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8541c0554a7138cf6587885fc6ed16995a1f70f5dd5aac19efce72ea42fb8661"
  end

  depends_on "php"

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
