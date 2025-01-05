class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/yorukot/superfile"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "ef632479edd6db89825589f7c52c2c46af92da0f5622b5b315e7bf6a600150cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7698cf92a6abffb9221eecdc298c4b7e3d8a4dbc30df00450a7e9b7afe9c088c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648bb599755517b942984fda7fabc0cf244bed72fd7dfd4725a2dcc39a7f7d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "044266442c1cfdbd5f708a33a74770e4378d61e690b694b024ccb846dd5c99b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "524ba80563fe7f3b1f19ddabe992ec4d1a480890e6f46eb1f17e23dcc1833f85"
    sha256 cellar: :any_skip_relocation, ventura:       "f35383b7a56588a6c2b2a695f81772c9b76e0ef0a42d83cbc94c932f2d607334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd9490c4bf1382bd8b72d2575b5de8056f30080afc31b6301ccfb21928a8034f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
