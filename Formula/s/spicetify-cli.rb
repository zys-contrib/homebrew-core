class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.37.6/v2.37.6.tar.gz"
  sha256 "ddd58a8ff0328750bb30cbb976deae9e1e4350f8aa2dfcd0803917d1765d5742"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bba35bf4c04bca0ce8d7745fb4b58437f59abeeda000d22754ec7b1f41599e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bba35bf4c04bca0ce8d7745fb4b58437f59abeeda000d22754ec7b1f41599e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bba35bf4c04bca0ce8d7745fb4b58437f59abeeda000d22754ec7b1f41599e68"
    sha256 cellar: :any_skip_relocation, sonoma:         "6422c0a0370fff6c51fcbf19c59bf80b0bbafccd1d5f9d98699ed6bd58554cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "6422c0a0370fff6c51fcbf19c59bf80b0bbafccd1d5f9d98699ed6bd58554cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "6422c0a0370fff6c51fcbf19c59bf80b0bbafccd1d5f9d98699ed6bd58554cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aaa5062fa4efbab66d466b3d3288018c23a4e9bb3a3a3dd25404610bec2e1fc"
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
    assert_match "SpicetifyDefault", shell_output("#{bin}/spicetify config current_theme")
  end
end
