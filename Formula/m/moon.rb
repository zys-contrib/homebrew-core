class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "4485184d09cf476697e8f4934ba062a42081874979bd47308929056d8a4d1bd1"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89beb00fdedf01a4c7b9dc778bfd779524c0786a8b44230f24ee54d3cfc2c5a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d084ea8e8ea7b909e54d71e865df8886342c65eaccbe1a383df2f7c0e7531693"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d66097e784024336fdaec35d07787f55061e4165ebd20ddd56aa3c8cdd71e59d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e40045c5192da02d2f93ba76c3853dfbd081d444940b23f459eed608652fe12"
    sha256 cellar: :any_skip_relocation, ventura:       "4cd28c87e78a01cf39dba714815a0f8c78ae5687135804f188b8e850fa8d2478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336efd1a2071a4b193a610b2ae7bd60a878c495d8d05f6ce872913812fd94fe3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
