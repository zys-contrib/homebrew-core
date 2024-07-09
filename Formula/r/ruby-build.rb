class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20240709.tar.gz"
  sha256 "0b52f815733e09266e0499d75852edf2efb211e4abbe5f941d08a1ddf75437ae"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93eff75df85b57532beb27602ad643bd045323c8e0e26e866901055fc2941e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93eff75df85b57532beb27602ad643bd045323c8e0e26e866901055fc2941e30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93eff75df85b57532beb27602ad643bd045323c8e0e26e866901055fc2941e30"
    sha256 cellar: :any_skip_relocation, sonoma:         "93eff75df85b57532beb27602ad643bd045323c8e0e26e866901055fc2941e30"
    sha256 cellar: :any_skip_relocation, ventura:        "93eff75df85b57532beb27602ad643bd045323c8e0e26e866901055fc2941e30"
    sha256 cellar: :any_skip_relocation, monterey:       "93eff75df85b57532beb27602ad643bd045323c8e0e26e866901055fc2941e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ad1ea3d42c1462198a7056f7ab29bdeb3937fe8736ca80ee7376c0dc2564b2"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "bin/ruby-build", "/usr/local", HOMEBREW_PREFIX

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
