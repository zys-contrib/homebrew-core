class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.16.2.tar.gz"
  sha256 "3067f21a0025aedb5869c7080b6c4b3fa55d397b94fadc8c3037a28a6cee274c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b7540c2d75c431e7954cefb4f156718a6e8c87caafb8b236f5966e7f0944668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b7540c2d75c431e7954cefb4f156718a6e8c87caafb8b236f5966e7f0944668"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b7540c2d75c431e7954cefb4f156718a6e8c87caafb8b236f5966e7f0944668"
    sha256 cellar: :any_skip_relocation, sonoma:        "c89b08df220841347a82abfb31fd4b65ae5c7c411bf079092361cb1bda016c0c"
    sha256 cellar: :any_skip_relocation, ventura:       "c89b08df220841347a82abfb31fd4b65ae5c7c411bf079092361cb1bda016c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f6625b5ae17fc7157f439c3f78c6033342df3677267cfa58576c6153364e24"
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
