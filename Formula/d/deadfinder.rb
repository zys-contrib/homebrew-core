class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.3.5.tar.gz"
  sha256 "d87efcfabbbb85307c8b90dd39e3da086d402d2dde11b1ad0837a3713deec435"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13112d308342939cd50aeb6eb71b53e0c0fc71fbaf5b099ce743ef1a4da1fc25"
    sha256 cellar: :any,                 arm64_sonoma:  "e1c22bbac4c30a4dbb8304420cea2427765477cc85b5ea3991c0e591c16541b3"
    sha256 cellar: :any,                 arm64_ventura: "5bab97de2acdf9eb96b2b04ec6850a2f18e8f01efa23bfcf46c98493f0317aa9"
    sha256 cellar: :any,                 sonoma:        "1907c911986c833eaa6681c1d766e0e8de8105dbe4225787b6678c3242e4001e"
    sha256 cellar: :any,                 ventura:       "b7ae3d715cbd5dc90281949bbf9addf136b2809d32c488fa50555463576bc7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ecc0a046af5d413b070b8f65978f3bf85cf6d38e051e9b54c81ca882d7e15b7"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Done", shell_output(bin/"deadfinder url https://brew.sh")
  end
end
