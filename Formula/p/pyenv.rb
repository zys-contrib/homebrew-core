class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "4844d4cf66aed4243201fc19680888d7e8b6d63bffa4f924665f5b5926370bb6"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d654b3cfe26e5355d1f6cd547e26fcd567f9c035245a1c5066d9ff04ff12e47"
    sha256 cellar: :any,                 arm64_sonoma:  "378dc091255b9d589c79a217111d6d0a2c922284cbe8e7d81575b3add8129c55"
    sha256 cellar: :any,                 arm64_ventura: "339619826129d8d04000eca3174c86ef1038db73f8edf4d3786a70e2ca3eb1f8"
    sha256 cellar: :any,                 sonoma:        "d092f48b7c0a0200c79c4e714ed3d3e50bb3503e7ab580136efc251c21a94c6a"
    sha256 cellar: :any,                 ventura:       "3977be932f4445e8d98d49f02d4cfe011b922dee3d62be84a924ed65eaed7530"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "219c2c65107fe21e552390d777dfb0fec71855d66d4157aea0c63a155a1d91ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc0042833ca4535475369ef88deccd35938ef876a8ad9668c8368dc0b8d4b81"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    share.install prefix/"man"

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("#{bin}/pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& #{bin}/pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end
