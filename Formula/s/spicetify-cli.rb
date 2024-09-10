class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.38.2/v2.38.2.tar.gz"
  sha256 "8d5ebe085dae80ccf657e13e0f0d22da29ba3782fa5c9c5be213f65028c2522b"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a41cc37ac8d5e88de1cf84d7addd860a8e4a64e655f69c0dece926163e1052b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a41cc37ac8d5e88de1cf84d7addd860a8e4a64e655f69c0dece926163e1052b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a41cc37ac8d5e88de1cf84d7addd860a8e4a64e655f69c0dece926163e1052b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf7b879b2a9eeb6626d883c5c9b62b96d23b03ed1ba71c265e73121125be7471"
    sha256 cellar: :any_skip_relocation, ventura:        "cf7b879b2a9eeb6626d883c5c9b62b96d23b03ed1ba71c265e73121125be7471"
    sha256 cellar: :any_skip_relocation, monterey:       "cf7b879b2a9eeb6626d883c5c9b62b96d23b03ed1ba71c265e73121125be7471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e25eaac8e53f49a34352831f45cd538b0f6f9aa874ed7b276fd0e46d81ae5f86"
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
