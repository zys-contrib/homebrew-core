class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.13.3.tar.gz"
  sha256 "21c8eaa53cf3290d2b1405c8cb2cde5f39bc14ef597b328e76f1789b0ef3539a"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d9832c85fa3c1464e93420373e32fd542b76b05e86ea546f7005453aac095a76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34e8c78fc1fc56c70c0d6469f0231030ad9e9c6e1cffdf1b5cd7bc87be312cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ebf7214a79378f14c0bb5f9ec95ccd623c0d3190690a3e4f9831ffba9e05784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d4610105bd7f6adbe20342f5e906372157bcf1ebd1fec4be388dbf890502ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "c14260ad3090eab871b648736ecb1b869ed149ff32c65bdd87c162377ab7b926"
    sha256 cellar: :any_skip_relocation, ventura:        "40543ec436ab8d7b5a1e78113dcc1aa7caa3b897c95eac6e19acf1a7deb372f6"
    sha256 cellar: :any_skip_relocation, monterey:       "91328a0c8db799b5bb9d943232b4e59b366a954181bd879cef514d5c4d0198e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f529fe1b6db0517fd3880d55aa07af4c5cfae107a2ce0a5674adcacd092cda"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build, since: :catalina

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "python@3.12" => :build # https://github.com/rust-skia/rust-skia/issues/1049
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@76"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libxkbcommon" # dynamically loaded by xkbcommon-dl
    depends_on "mesa" # dynamically loaded by glutin
    depends_on "zlib"
  end

  fails_with :gcc do
    cause "Skia build uses clang target option"
  end

  def install
    ENV["FORCE_SKIA_BUILD"] = "1" # avoid pre-built `skia`

    # FIXME: On macOS, `skia-bindings` crate only allows building `skia` with bundled libraries
    if OS.linux?
      if build.stable?
        skia_bindings_version = Version.new(File.read("Cargo.lock")[/name = "skia-bindings"\nversion = "(.*)"/, 1])
        odie "Remove `python@3.12` dependency and PATH modification" if skia_bindings_version >= "0.80.0"
        ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"
      end

      ENV["SKIA_USE_SYSTEM_LIBRARIES"] = "1"
      ENV["CLANG_PATH"] = which(ENV.cc) # force bindgen to use superenv clang to find brew libraries

      # GN doesn't use CFLAGS so pass extra paths using superenv
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", Formula["freetype"].opt_include/"freetype2"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", Formula["harfbuzz"].opt_include/"harfbuzz"
    end

    system "cargo", "install", *std_cargo_args

    return unless OS.mac?

    # https://github.com/burtonageo/cargo-bundle/issues/118
    with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
    prefix.install "target/release/bundle/osx/Neovide.app"
    bin.write_exec_script prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  test do
    test_server = "localhost:#{free_port}"
    nvim_cmd = ["nvim", "--headless", "--listen", test_server]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 10

    neovide_cmd = [bin/"neovide", "--no-fork", "--remote-tcp=#{test_server}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
