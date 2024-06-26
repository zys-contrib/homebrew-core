class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "23ea0bf89fdb86a0817c1f38da5c957597dce61e76f0bdf1ed1d0ae004683229"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d218ad85283fd32c1a1161d6ea490663567f4e806596c1188deab0010e72c625"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6993d53aab78f433cc53ba68095c0a2a4eb373816ebc3960309cc45561756539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf86663d1e19706edf2e24593d86b1c5d812c03ab73567a9a9ca3d4dfa0d0541"
    sha256 cellar: :any_skip_relocation, sonoma:         "f56af76f4e36cf56f631afb58089b37be80d1e233a8353754af7b1128d3b2e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "044adf428cfd99dc71fb8d0d6e0c556a4665bb7f7f13d52bc0558aa8b490389a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ee64e3041b01e6ace444c2768897f1c10d69c700f3a7b1dbebfe5ba708ae080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ef739dc0cd2a10257b67383945ffdaf2db88839c4ae99150737117d81a8d13"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end
