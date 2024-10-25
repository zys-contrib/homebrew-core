class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "bfcd950178023909b0854bc6bded5b57d1c00123943e9dbcdfddf2a632c71ff4"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "release", "./cmd/carapace"
  end

  test do
    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
