class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.4.307.tar.gz"
  sha256 "6e8445bc12c1e2702c27f4f02d1a057fb83f40cc56c6a8e4583141d4eaad90d4"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a5b803fb7d512c9e9770ebe2234e664862d0e695cb71da06663d0903b46b27e"
  end

  depends_on "cmake" => :build

  def install
    # Ensure bottles are uniform.
    inreplace "include/vulkan/vulkan.hpp" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
