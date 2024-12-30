class Runitor < Formula
  desc "Command runner with healthchecks.io integration"
  homepage "https://github.com/bdd/runitor"
  url "https://github.com/bdd/runitor/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "d654d4fb55b2adee445d2160ec937529f9a052220554a46874a8a5c64c52be06"
  license "0BSD"
  head "https://github.com/bdd/runitor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/runitor"
  end

  test do
    output = shell_output("#{bin}/runitor -uuid 00000000-0000-0000-0000-000000000000 true 2>&1")
    assert_match "error response: 400 Bad Request", output
    assert_equal "runitor #{version}", shell_output("#{bin}/runitor -version").strip
  end
end
