class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.13.2.tar.gz"
  sha256 "d7c788fd55673aef59567f75f061255c6243db583d3bfd5944768b3ee6510cee"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/wtr.watcher . -ms 1")
    assert_match "create", output
    assert_match "destroy", output

    (testpath/"test.c").write <<~C
      #include <wtr/watcher-c.h>
      #include <stdio.h>

      void callback(struct wtr_watcher_event event, void* _ctx) {
          printf(
              "path name: %s, effect type: %d path type: %d, effect time: %lld, associated path name: %s\\n",
              event.path_name,
              event.effect_type,
              event.path_type,
              event.effect_time,
              event.associated_path_name ? event.associated_path_name : ""
          );
      }

      int main() {
          void* watcher = wtr_watcher_open(".", callback, NULL);
          wtr_watcher_close(watcher);

          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwatcher-c", "-o", "test"
    system "./test"
  end
end
