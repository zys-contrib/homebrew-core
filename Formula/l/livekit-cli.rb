class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "a357acdaa0a6af7fde9236597fa6e17b8a6b3f41ebf796780bfc46a1bb7e0df9"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab131932002a312d25a984d4e198c08dbb7d59955f7a0e4b5fefeebbf0f129ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3baba6f55824a15a4a2c255c3ca44f316c4bf8ca294aab7146b7e76412cfd4c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97c4ffcfa768c97b7063e8eb99af3f43e204792ac766fcb3916b3a289f0ae68"
    sha256 cellar: :any_skip_relocation, sonoma:         "73ff2fdbdbdb5ad54f212334d7f3929b92a418e505bdddcd7df5a8388839d66d"
    sha256 cellar: :any_skip_relocation, ventura:        "1dc5bdd953fa2dcf0255ebb7921b133e8e51e42b4766c1a59d20a601f9c24b68"
    sha256 cellar: :any_skip_relocation, monterey:       "4ac91d65208750ce1bf34351ad0238dd6e25becc8f74016dfd5854212205770b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84a7c504efe4a1949ee3d14bfb93dbe171bc8f6f210c89ca3671b1188913241"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
