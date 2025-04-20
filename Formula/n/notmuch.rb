class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.38.3.tar.xz"
  sha256 "9af46cc80da58b4301ca2baefcc25a40d112d0315507e632c0f3f0f08328d054"
  license "GPL-3.0-or-later"
  revision 4
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "055eeba042bccbd7a389fe201798c8fc976752481fd1be8b234f14df6d092e9f"
    sha256 cellar: :any,                 arm64_sonoma:  "f9405e751f351f182de74399d9e9ae9dcc01e87d088c09bdd367af08e7dc8469"
    sha256 cellar: :any,                 arm64_ventura: "a4532931662794b5fa746ba26e141ddbd92778f3c27e1db56e2f35a350baec91"
    sha256 cellar: :any,                 sonoma:        "5e63a25c377c0329cc752aa5891b638339bcbf718e4f8a89547c71bac3d047c6"
    sha256 cellar: :any,                 ventura:       "3cd52d5dd1807606688cfc66be30558e2d9dc952951bd54a051f10ebf05e5a1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec340caf377ef7b4c1c1e2c4eeaec0e46f427ffead447f73b1422e0a01a0cdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12ea4b3c8b6a052b9784602a0e4ad03b8b99905c0a0f06096a7a0b867c1ac9f"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.13"
  depends_on "sfsexp"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.cxx11 if OS.linux?
    site_packages = Language::Python.site_packages(python3)
    with_env(PYTHONPATH: Formula["sphinx-doc"].opt_libexec/site_packages) do
      system "./configure", "--prefix=#{prefix}",
                            "--mandir=#{man}",
                            "--emacslispdir=#{elisp}",
                            "--emacsetcdir=#{elisp}",
                            "--bashcompletiondir=#{bash_completion}",
                            "--zshcompletiondir=#{zsh_completion}",
                            "--without-ruby"
      system "make", "V=1", "install"
    end
    bin.install "notmuch-git"
    rewrite_shebang detected_python_shebang, bin/"notmuch-git"

    elisp.install Pathname.glob("emacs/*.el")
    bash_completion.install "completion/notmuch-completion.bash" => "notmuch"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    ["python", "python-cffi"].each do |subdir|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./bindings/#{subdir}"
    end
  end

  test do
    (testpath/".notmuch-config").write <<~INI
      [database]
      path=#{testpath}/Mail
    INI
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    system python3, "-c", "import notmuch"

    system python3, "-c", <<~PYTHON
      import notmuch2
      db = notmuch2.Database(mode=notmuch2.Database.MODE.READ_ONLY)
      assert str(db.path) == '#{testpath}/Mail', 'Wrong db.path!'
      db.close()
    PYTHON
    system bin/"notmuch-git", "-C", "#{testpath}/git", "init"
    assert_path_exists testpath/"git"
  end
end
