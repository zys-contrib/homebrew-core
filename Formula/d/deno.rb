class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.3.3/deno_src.tar.gz"
  sha256 "1a0f6b294a02d3d43c84ee085f1b6d63452fd3899de7dc80e4c03ea8b9d73801"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cdbca1fbf9c9c25b40f1ed34a009a6b9e62511b9a2bc05b1823d8a05ecb8d75"
    sha256 cellar: :any,                 arm64_sonoma:  "035b67118469e32d123adf38f0427c48d747acba707fe5546e7ae57b9c5a0233"
    sha256 cellar: :any,                 arm64_ventura: "340986868d8e401be89dae17a7ceab0ea6588f3bc95e96c00c579f42780473eb"
    sha256 cellar: :any,                 sonoma:        "4b169082e76f7ad65205dd78693b806edd0ae1b10fb99085c57dd8752a5abf9f"
    sha256 cellar: :any,                 ventura:       "60b36291b8d253537b76622c7c838e8da30d119e1ed1f78a3d670823db83b949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4215648195c83ff3c58777bdc7291e3ef1a681cf91c48128d9d24b5037be0397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f9b21c20991e98d195b0bc34cd5cff38dd10ed19fbc5d7ad1663cb7a261dd0"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  depends_on "little-cms2"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glib" => :build
    depends_on "pcre2" => :build
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Avoid vendored dependencies.
    inreplace "Cargo.toml" do |s|
      s.gsub!(/^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }')
      s.gsub!(/^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session"/,
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"')
    end
    inreplace "resolvers/npm_cache/Cargo.toml",
              'flate2 = { workspace = true, features = ["zlib-ng-compat"] }',
              "flate2 = { workspace = true }"

    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib
    # env args for building a release build with our python3 and ninja
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=#{OS.linux?}"

    system "cargo", "install", "--no-default-features", "-vv", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    require "utils/linkage"

    IO.popen("deno run -A -r https://fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath/"fresh-project/README.md").read

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("hello", "deno");
    TYPESCRIPT
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}/deno run https://deno.land/std@0.100.0/examples/welcome.ts")

    linked_libraries = [
      Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
