class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.9.1.tar.gz"
  sha256 "28234378f7673e9a88521e5a74d8272df83be87c7b743460a6c88dde21c5f9cd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92f60f762b599c4464e88f4a5f1dfcbb5bcded76c83efda30068f2025b49aa30"
    sha256 cellar: :any,                 arm64_sonoma:  "73d63538e190b5bd973b2c55a906cac7aaca39ad0715e42fccc63a959d479688"
    sha256 cellar: :any,                 arm64_ventura: "93beb1ab0d866de14bdecf292117266181446fd8e262b244f5f7e1cce56fac40"
    sha256 cellar: :any,                 sonoma:        "3ed21be467d60d1aef72aca11ece1fcf9ace6730a24c7ab8e1342c58fb72e9db"
    sha256 cellar: :any,                 ventura:       "2d2682f719c05bf360d1f151759fb0df4a19aa3669b40c311b770242cbafe901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1accca2d383866a4b2b8d8b995a0aa1d442a55a3749200cec577ab9d2b56aa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "132053f6c75c555413460b4416babf0e88050f27270b95f1f70c58a9e11743b9"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "7fbf89065fbb0d26526278a5e733270f83993cda"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "e24b0f9e760e27464fe2ed30fdd7be45a27a67ad"
  end

  # No recent tagged releases, use the latest commit
  resource "libunwindstack-ndk" do
    url "https://github.com/getsentry/libunwindstack-ndk.git",
        revision: "284202fb1e42dbeba6598e26ced2e1ec404eecd1"
  end

  resource "third-party/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        tag:      "v2024.02.01",
        revision: "ed31caa60f20a4f6569883b2d752ef7522de51e0"
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
