class Funzzy < Formula
  desc "Lightweight file watcher"
  homepage "https://github.com/cristianoliveira/funzzy"
  url "https://github.com/cristianoliveira/funzzy/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "9c98ff08a611a8c3fc9eedd5bc56ecdc9fbd7ec5630d020cd1aa7426524df3d3"
  license "MIT"
  head "https://github.com/cristianoliveira/funzzy.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"funzzy", "init"
    assert_match "## Funzzy events file", File.read(testpath/".watch.yaml")

    assert_match version.to_s, shell_output("#{bin}/funzzy --version")
  end
end
