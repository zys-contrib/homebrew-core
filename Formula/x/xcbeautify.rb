class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.19.0.tar.gz"
  sha256 "cc6147c51c9ecb844d106874135818c5ac665454f773035bb4ee9415dda2f594"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b1a8a18e7a79e13f023aa298a4d96d05f6137c5f32769ed54c3a537b04fcbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539dd4c92488f30701acf38583a3a602baea5cdaf799c4648879b8eef093d7a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9eaa1e83e4b88323c014514ebcd15799d7dab85fcaf82012d579585b12330df0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d292eb1018bc17962f59ff1684b125f12af4a53691e805d0c943ffc868236e57"
    sha256 cellar: :any_skip_relocation, ventura:       "108d4cc8fffddf3baa8e93e95a8153cf8eb083c0c8f17c90b6b5e1259d390d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d194e98ec00ddd04c3087130ed8ddb26ed375d58dd45fe410d40f2ba01ce2dc"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
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
