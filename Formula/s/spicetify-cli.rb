class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.40.0/v2.40.0.tar.gz"
  sha256 "8b167789fb64cf87e1b74f49b28a4e500f0cbcb1228a7bcaec0253cdaf86a34a"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd904ad0dd6524814857b485e767189855a7c222fc8d9246d053cf132288418e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd904ad0dd6524814857b485e767189855a7c222fc8d9246d053cf132288418e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd904ad0dd6524814857b485e767189855a7c222fc8d9246d053cf132288418e"
    sha256 cellar: :any_skip_relocation, sonoma:        "348e98605ba17ed1964d92faae4864abf33492d64d6301efe5257ca6132fb10f"
    sha256 cellar: :any_skip_relocation, ventura:       "348e98605ba17ed1964d92faae4864abf33492d64d6301efe5257ca6132fb10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2a4f666a0ee4add99fa88277a94db0a2854eecd94302127c4ee275498422b4"
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
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end
