class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "947dfdab6c1417c7c43efef2ecb7a92a3c339ce2135233fe88323740e6e7fab1"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f23dc2fe7745455849b033d6712c5ff3643ac808f8f01937d9b4e9aa91ebd3eb"
    sha256 cellar: :any,                 arm64_ventura:  "09462a857516308f1cb2656ce2ea1b8650d99248cc03922562d06ea00ff69327"
    sha256 cellar: :any,                 arm64_monterey: "9f00e07b9bb4e8992897946ee0624903d0959d0555e3cd7692e7bb0891f4df18"
    sha256 cellar: :any,                 sonoma:         "b664fd171581eff8671c0a4f0d242edc5cc4a02204cb85033772ce763675d8d8"
    sha256 cellar: :any,                 ventura:        "2bc94172b9ef49568106a182fe0d02153425c625c04fba6ecedb334c2d402d5a"
    sha256 cellar: :any,                 monterey:       "a6fc8c13e8bc6eb8dc7cf9205ef8d69cd30900e9b4e11b52436895a030b366b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31581c3ce8ea833fe2a60d42ce0879093be588c37d4336910dc59f891aa40eba"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end
