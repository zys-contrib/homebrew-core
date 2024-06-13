class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "39b9d54440b82cd78c8448cb9687c2fa43b4cdb0e629f8981d73ce2ad63350bf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5aa96beafb42dbe58ab41409b11c38db2a2dd204a919178044dfcc330456467"
    sha256 cellar: :any,                 arm64_ventura:  "b54f4de814b2178a1a9e6651b508825c557a4b85561b6696f0b44d538d59b672"
    sha256 cellar: :any,                 arm64_monterey: "fc54af35a5ad00e5fa9489393d3ac072830b8f7b80a2de4c1778617cdd6e0b95"
    sha256 cellar: :any,                 sonoma:         "e8f3f361eeed8703733103de20fc2bcdf02bf98598322eff3d23e7a679303a72"
    sha256 cellar: :any,                 ventura:        "e789d10298bbdedaf5cd6e1a26bf0316b82ae5e3e0cdae078b6c441f92bf6a17"
    sha256 cellar: :any,                 monterey:       "9dd920a2745da6da3a71ba0858602b81030a8195bcedc8734771254ef569dce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b9da2455b698d0df85a0ce45327bade205e501f571ddbf60def964403f67aad"
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
