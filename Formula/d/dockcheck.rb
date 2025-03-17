class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://github.com/mag37/dockcheck"
  url "https://github.com/mag37/dockcheck/archive/refs/tags/v0.5.8.0.tar.gz"
  sha256 "bb9c5b5868496188ba001c8a81acf34da1e774886571819ab636ef80afc6a56d"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  depends_on "jq"
  depends_on "regclient"

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "No docker binaries available", output
  end
end
