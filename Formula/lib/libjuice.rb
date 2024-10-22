class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "48e7af76ffa553f500a428b8bcb067ebc93e03b4d803ef431540658ab7a4fce2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3373d4a0d1d6f2452c57ee163e46a5a2884174378b785ea8844afd0701717153"
    sha256 cellar: :any,                 arm64_sonoma:  "9212fbddf58ebb0144a7fa8d54ac7d260ef0e4687e5550b5302bdc62399f160a"
    sha256 cellar: :any,                 arm64_ventura: "943b7988a31a41c8d6a0562418d442907f6fa0f76ccd5c6bfbb319563d0950e8"
    sha256 cellar: :any,                 sonoma:        "0fc3a52044f38d11db83877c7a7848e4642f26a25a98226e3af544d1f2abae11"
    sha256 cellar: :any,                 ventura:       "3d6783952b0e9d04a2d307be85431ee1f6b5a8a2b843dc2153af3f49649943b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f591746a264c97f07c7c05ee7468fd4a8190ac43354d4c47a4758b7d35e9bc9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DNO_TESTS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "juice/juice.h"

      int main() {
          juice_config_t config;

          config.stun_server_host = "stun.l.google.com";
          config.stun_server_port = 19302;
          config.turn_servers = NULL;
          config.turn_servers_count = 0;
          config.user_ptr = NULL;
          config.cb_state_changed = NULL;
          config.cb_candidate = NULL;
          config.cb_gathering_done = NULL;
          config.cb_recv = NULL;

          juice_agent_t *agent = juice_create(&config);
          printf("Successfully created a juice agent\\n");

          juice_destroy(agent);
          printf("Successfully destroyed the juice agent\\n");

          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljuice", "-o", "test"
    system "./test"
  end
end
