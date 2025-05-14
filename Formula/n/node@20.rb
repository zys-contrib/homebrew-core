class NodeAT20 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v20.19.2/node-v20.19.2.tar.xz"
  sha256 "4a7ff611d5180f4e420204fa6f22f9f9deb2ac5e98619dd9a4de87edf5b03b6e"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "6dbede32ed7d323ceeed43a83789824ab7cdfaf9df92041a2486eb522ca6769e"
    sha256 arm64_sonoma:  "055407d0f413c52142e700b193a4fac6b309e4e6bc90a14e6f7ee59d848d18d2"
    sha256 arm64_ventura: "cd12c0e1b8d6bf21f683165fbaf5cf59826d9e9b153edd279e2903275bd7547c"
    sha256 sonoma:        "a5d4e6820e57c3ffc0e18ca743d8b691e9c4767a8446fede3033bf0fe9c712f4"
    sha256 ventura:       "27208e60a4e8c5efeb422ae6511e4a7e8136ab68e7c1d8b7122d41f386fac6b2"
    sha256 arm64_linux:   "204ccf94c351e5d9b53cc06e3954f60afb4d1abfe623c5182cafd652bff9acef"
    sha256 x86_64_linux:  "839975a075d3f16bf8d6cc47e229b8a3a0bbd43146356bba927de449135dcbb8"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2026-04-30", because: :unsupported
  deprecate! date: "2025-10-28", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@77"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: calling a private constructor of class 'v8::internal::(anonymous namespace)::RegExpParserImpl<uint8_t>'
    EOS
  end

  # Fix build with Xcode 16.3.
  patch do
    url "https://github.com/Bo98/node/commit/3b5eb14cad3a493e99f84ca45871bd37570cae3d.patch?full_index=1"
    sha256 "3a110c30ec63c4e5afbb48f27922a69c40d3939db5a5b6b20d40660f996ae27d"
  end
  patch do
    url "https://github.com/Bo98/node/commit/e2ab76c1aeceaf866b8c5053cf71f199706d621d.patch?full_index=1"
    sha256 "b306c7cfa910e025b1a23fda1da8f8613310a2d7b5c575d3718529db8d9e7fdd"
  end
  patch do
    url "https://github.com/Bo98/node/commit/a56d782971c30164545e76a97b07ade373a3a565.patch?full_index=1"
    sha256 "86af038fca81170d41e7c324864cc74fb098dbea6b8d28273b6b50ca53415979"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The new linker crashed during LTO due to high memory usage.
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.13")

    args = %W[
      --prefix=#{prefix}
      --with-intl=system-icu
      --shared-libuv
      --shared-nghttp2
      --shared-openssl
      --shared-zlib
      --shared-brotli
      --shared-cares
      --shared-libuv-includes=#{Formula["libuv"].include}
      --shared-libuv-libpath=#{Formula["libuv"].lib}
      --shared-nghttp2-includes=#{Formula["libnghttp2"].include}
      --shared-nghttp2-libpath=#{Formula["libnghttp2"].lib}
      --shared-openssl-includes=#{Formula["openssl@3"].include}
      --shared-openssl-libpath=#{Formula["openssl@3"].lib}
      --shared-brotli-includes=#{Formula["brotli"].include}
      --shared-brotli-libpath=#{Formula["brotli"].lib}
      --shared-cares-includes=#{Formula["c-ares"].include}
      --shared-cares-libpath=#{Formula["c-ares"].lib}
      --openssl-use-def-ca-store
    ]

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # Pre-Catalina macOS also can't build with LTO
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && MacOS.version >= :catalina && build.bottle?

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    # Make sure Mojave does not have `CC=llvm_clang`.
    ENV.clang if OS.mac?

    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

    # make sure npm can find node
    ENV.prepend_path "PATH", opt_bin
    ENV.delete "NVM_NODEJS_ORG_MIRROR"
    assert_equal which("node"), opt_bin/"node"
    assert_path_exists bin/"npm", "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "ref-napi"
    assert_path_exists bin/"npx", "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end
