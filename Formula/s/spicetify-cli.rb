class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.38.5/v2.38.5.tar.gz"
  sha256 "bb72f491552d0f8fbe0ab3195c70884e8c4eb9c588f17ec77dcb4494aec70e52"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d58f63ab5d2bc403de5ce40174f60f7f31a53b49db68e5e8ca716866e683240a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58f63ab5d2bc403de5ce40174f60f7f31a53b49db68e5e8ca716866e683240a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d58f63ab5d2bc403de5ce40174f60f7f31a53b49db68e5e8ca716866e683240a"
    sha256 cellar: :any_skip_relocation, sonoma:        "82cd5f6c21b5275bbdf5b00caef7dbcd30969ec577169c518849e3e5a4f9b5f8"
    sha256 cellar: :any_skip_relocation, ventura:       "82cd5f6c21b5275bbdf5b00caef7dbcd30969ec577169c518849e3e5a4f9b5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "059087fd4f8d1ebe6d46917f1d9ab88f95947606fb2fa62ae96828b01c21b684"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec/"spicetify"
    end
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file
    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~EOS
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    EOS

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end
