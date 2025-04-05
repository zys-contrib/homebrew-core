class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.4.6.tar.gz"
  sha256 "541cd65c3f325c2fbaa87c875174c4470d8293a6215db5e212be609796e8cb89"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3ba015c529f99c57612e9b97652cec295132ce830bc48bbdb32c3de19f11257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49f2f77044d04fe255e8e165c69325d7a44fd05a2e860956189eee145fc29e86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aba29f0000092979ef84d584a26e0f90d7deab6823715395e7c0dbecbb7c412e"
    sha256 cellar: :any_skip_relocation, sonoma:        "88742b22d883d4916494d3778ebb62e1f6d77e5caead1b718c19ba599b4ded68"
    sha256 cellar: :any_skip_relocation, ventura:       "e2f90ac8d8591c75bafdfb6c018b4ff5fc11158f7b375c12e6e27919c9d211b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3db9b53da41520a3e28289f98391cf1aab5ae209b550e291263c5d242bd2858"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
