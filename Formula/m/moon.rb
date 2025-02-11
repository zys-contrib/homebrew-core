class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "93c0ab8bb240c209a78ff14c3e61797b7a2f404a91a49fe078f5e92bfaaeb970"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84767dc0252f416a3c81447d146928e891ab78be0c665e86b979ef709236bc89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8e7530972737d6c37b3ea0f77b76311b29cce9efee14af82892c7f49bbc2c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a75fb9d61e82d79108dc1acf7ca06f9c0d544a783c29b6fd45bed32a5feb3c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73afdb305acd500c93d25a3726c39192aa7bbb707bad59c0cbdd4d5dbe30945"
    sha256 cellar: :any_skip_relocation, ventura:       "1be3c04dd807221a5e96078e462fdc77fd9cda0a25cbbead4d9208444d4e25ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138312cf5e937be2f4a8875d6fe7dade3be0468bb1c9490d6ea52f9e21f2a6da"
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
