class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.46.tar.gz"
  sha256 "6e6815336761caabd9f42c71784dcf5c127f588805fb07bc448e30e3952c4201"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc813714bd1ad949fab49aecdd48751b68ba0757f93c9e6441f4984f3bf168e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b92f5b84459e34fa7dec10f70f043f775b861b9aebb6606ef9a35db0391cce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63b59ce39dfd079a02db84227a85fdc3b3acfb7278833d6417cf323956172da8"
    sha256 cellar: :any_skip_relocation, sonoma:         "36e27b2b3ede8656661e7f877e31647c64b42ea2bc1f24493897da62fda0e3dd"
    sha256 cellar: :any_skip_relocation, ventura:        "ce0fcf35dd170616e5181383671ada25b438c5b8043ee960978274cbc7c71293"
    sha256 cellar: :any_skip_relocation, monterey:       "07ae58b25477efabe3e82f82106e0a1766c2abb9315fc027a8608aa17cde614c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744c8935761fb34e5418ae690fd8d915770115e153d40da878d16f1fca8ad0ae"
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
