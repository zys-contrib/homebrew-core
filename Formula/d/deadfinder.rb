class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.6.1.tar.gz"
  sha256 "89eb3ce461b89b486220fa61579cda71c2ea90a261588a98f58cc66202883b82"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb7ed269a605c0acfafdde4085a3c9b5bf24018f00d4a85df542ae1c2046d072"
    sha256 cellar: :any,                 arm64_sonoma:  "be710465e79181e2880bc69a15ff52cf36365e2c3e1af5947d0aa3392380a1aa"
    sha256 cellar: :any,                 arm64_ventura: "5473cab79e49332a43d8b2c284630da563b7647e696cbfb8dabaa5aefe61392c"
    sha256 cellar: :any,                 sonoma:        "ab72845f161f20a1114d0d14aef95dd210d1fb7c14a289da8f52746c2d023062"
    sha256 cellar: :any,                 ventura:       "ad83904da97ad2ecc03e2561f84d682739d8e61ebc2ad86646097d6d4c4c1f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570f5c3432f338c46a18e59ce7763ff011abdf3b6c0653bf2a80ce655f0de599"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "deadfinder.gemspec"
    system "gem", "install", "deadfinder-#{version}.gem"

    bin.install libexec/"bin/deadfinder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Done", shell_output(bin/"deadfinder url https://brew.sh")
  end
end
