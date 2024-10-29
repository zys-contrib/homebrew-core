class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.16.1.tar.gz"
  sha256 "71855f746ba021cbf17809b971c428515fa3db1afd2b9dbd8f87c656ef967591"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b8dc6cb6b8b68ea84618c9389ad592faf0b556742ef9649b71d7e0a464e4c8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8dc6cb6b8b68ea84618c9389ad592faf0b556742ef9649b71d7e0a464e4c8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b8dc6cb6b8b68ea84618c9389ad592faf0b556742ef9649b71d7e0a464e4c8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "57890afffc03d4ac6e1d55d51ed2bd966605ad6eb9c224a1b2cd093acecb5cc8"
    sha256 cellar: :any_skip_relocation, ventura:       "57890afffc03d4ac6e1d55d51ed2bd966605ad6eb9c224a1b2cd093acecb5cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6742ae98c38b8688cd43c8971a8ebcc5362c6214691e41508ebcd5522d815653"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pod", "list"
  end
end
