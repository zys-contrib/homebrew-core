class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.8.1.tar.gz"
  sha256 "65e3de5708e57f30e821a474f7bdd02bb8ccafd97b5553ec8ecb1791a161ef3d"
  license "MIT"

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, so we use the latest commit as of 2025-Mar-10
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad",
      revision: "ecff426597666af4231da8505a85a61169c5ab04",
      using:    :git
    sha256 "20e15b67753086d1b27d2a3fc7a37cb10af18b077a5c6d1a7405e4b3041d45a4"
  end

  # No recent tagged releases, so we use the latest commit as of 2025-Mar-10
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad",
      revision: "4cd23a2bedb49751d871da086b20b66888562924",
      using:    :git
    sha256 "1febdf3c48f5d090553398dd98fb18e8671d5f1740cdc3f4869e684264d454af"
  end

  # No recent tagged releases, so we use the latest commit as of 2025-Mar-10
  resource "libunwindstack-ndk" do
    url "https://github.com/getsentry/libunwindstack-ndk",
      revision: "284202fb1e42dbeba6598e26ced2e1ec404eecd1",
      using:    :git
    sha256 "af301bfdee1fe8ff47697a45ac04f3ba44264887aaa841961dc957226a987a92"
  end

  resource "third-party/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support",
      tag:      "v2024.02.01",
      revision: "ed31caa60f20a4f6569883b2d752ef7522de51e0",
      using:    :git
    sha256 "0946a1200f604f352d418d7f082b942074d036e4469841e8f3f04f2178fbb42e"
  end

  def install
    resources.each { |r| r.stage buildpath/"external"/r.name }
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sentry.h>
      int main() {
        sentry_options_t *options = sentry_options_new();
        sentry_options_set_dsn(options, "https://ABC.ingest.us.sentry.io/123");
        sentry_init(options);
        sentry_close();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{HOMEBREW_PREFIX}/include", "-L#{HOMEBREW_PREFIX}/lib", "-lsentry", "-o", "test"
    system "./test"
  end
end
