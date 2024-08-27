class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.37.5/v2.37.5.tar.gz"
  sha256 "8c37799b06f053bd9f95891c2de6814f189f054784db08183648590dcbe5d3b1"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1ff7586f2cea08498ec2045e47c759c54acec733b9793c2d076931597b062d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1ff7586f2cea08498ec2045e47c759c54acec733b9793c2d076931597b062d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ff7586f2cea08498ec2045e47c759c54acec733b9793c2d076931597b062d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3080d25fc532e22ddde2dc8df6e7bd5a5e75593ed065489e196b603e2b603113"
    sha256 cellar: :any_skip_relocation, ventura:        "3080d25fc532e22ddde2dc8df6e7bd5a5e75593ed065489e196b603e2b603113"
    sha256 cellar: :any_skip_relocation, monterey:       "3080d25fc532e22ddde2dc8df6e7bd5a5e75593ed065489e196b603e2b603113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffca3ded767755c3fdb15d13f7a2f229351698e72e35955efa3f0b6675228fc8"
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
