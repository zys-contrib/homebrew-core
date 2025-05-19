class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.40.8/v2.40.8.tar.gz"
  sha256 "e4c0c38f8f6676d9410db9b958e5ea08d7a57e1e7b95f444432b102d1aeb57c0"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "727587a887279feb5d565cdff59bbb240d247d76ffbb2826aa9c48e0e8ce5075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727587a887279feb5d565cdff59bbb240d247d76ffbb2826aa9c48e0e8ce5075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "727587a887279feb5d565cdff59bbb240d247d76ffbb2826aa9c48e0e8ce5075"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d63962a8f8e86d1e70b5cc240ab1bac48304027cf4e68e52a15d5784a07ccd7"
    sha256 cellar: :any_skip_relocation, ventura:       "0d63962a8f8e86d1e70b5cc240ab1bac48304027cf4e68e52a15d5784a07ccd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f48359df04728d044b5b64f228932071a862fbc4fe470a2f3683c586a54cf4"
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
