class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.8.0.tar.gz"
  sha256 "ab61627c4c9d9c2356568c69012241d7bd42416879cde7dcbed3eecb51b23dc5"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "742963a52ec783cf95dd68ba536022d6479d33b2150b29a6307958615fe81308"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01063c6b5f499f42e057b30c80b0bd13c862724a3f5ce2c5c12ae8b33005df3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c144af6baa574fdb5317ffa52287b4391b97399ca65233a08f5d2d24d7d96342"
    sha256 cellar: :any_skip_relocation, ventura:       "09d2c945ab01086479067537d080ae705a77b269cddfc28e9c8407f3b3480433"
    sha256                               x86_64_linux:  "02996f8673246a2032ece91a047d4f172edd6b376ddc0442107785ac4d34d5e5"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
