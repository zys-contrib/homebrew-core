class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.41.tar.gz"
  sha256 "14e772d13458f15d8d09e7ae387b40a34b4ce9cf6cbb50d0179264151941420a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27d160fbf5f17c0a193d007a4185e4dfe88889baa8b532b538034460c75adb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8712f60d3903e3c298c470b7bf7eabaa6925f95e4e638b03629804df7dcfff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb4e23056df28a4a5d2530cc932e6e837caaebccfabffcef36dc210267e788a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "81c963213c3cc7a440c97e536f78768171898d599c8951a93a27a593e1620714"
    sha256 cellar: :any_skip_relocation, ventura:        "e6de9acd76a4ea3757f56fddfe42764d2c6ae08600773595d85615506d539be5"
    sha256 cellar: :any_skip_relocation, monterey:       "4f83e525a19cee5d2992c0800873f0670f6ca1b271ff7f48b58c2fc097a434b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43050c7011f8e779dcfa556903a7d9a10ebc4d9634fadb12830dfc71805f6a79"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v36.2.1.tar.gz"
    sha256 "44e5087cd3c47058f9934b90c0017e4cf870b71619f99707dd433074622debb1"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    # We install `tcl-tk` headers in a subdirectory to avoid conflicts with other formulae.
    ENV.append_to_cflags "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" if OS.linux?
    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    sh_init = "#{prefix}/init/sh"

    (testpath/"lmodtest.sh").write <<~EOS
      #!/bin/sh
      . #{sh_init}
      module list
    EOS

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
