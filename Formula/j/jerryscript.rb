class Jerryscript < Formula
  desc "Ultra-lightweight JavaScript engine for the Internet of Things"
  homepage "https://jerryscript.net"
  url "https://github.com/jerryscript-project/jerryscript/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "4d586d922ba575d95482693a45169ebe6cb539c4b5a0d256a6651a39e47bf0fc"
  license "Apache-2.0"
  head "https://github.com/jerryscript-project/jerryscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "59cb985f4ad6dae1b6829ca5776e03389391294a5d53a79bec12225bd4d90033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cefb188b4e64c616b24fc6b7bffeac156cdcb2b7f32fe7f5fe1a84b5aa10c4bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fd5222f423cb3631821d682075287ffca06419089964788459ebfcfcd51eee8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9fc5ed6b4d4694e46177bad3a5b3b8b6542e088224e10a4797e7bff39313077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf6ac8f80cc4c6b10bd27113e49727d31cd6f8237e55362bd5fc6cb10fdfa9b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb468ff25bb25ed92190b7f09ba4d9350a74e5b22cee6044b951b38d4ce31585"
    sha256 cellar: :any_skip_relocation, ventura:        "1272a0788c46b580ed2736b94a60698c66a1b7b51b966a21c7045cd336f4cce6"
    sha256 cellar: :any_skip_relocation, monterey:       "fd07174dc19c1dc678c26de054b08b55cb4e0e5b425aed223a2f3c27bafece47"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7884dc63baf21ca21f882e25f93397f0478dba8e0c4728a7efc7bfb198673ff"
    sha256 cellar: :any_skip_relocation, catalina:       "e6e1907eb1af3d6aab2f3447a0aa2e6c709ebb040d6198fefa7c12a1e256b8bd"
    sha256 cellar: :any_skip_relocation, mojave:         "c091f4246186278785265a7c378f2cd37db337d4c9419afc8348bcdd4d74e8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0756095b89bd3051bf0c8bfb38b6dc8070b9eabe707afe77afe85698a69ad75"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  # rpath patch, upstream pr ref, https://github.com/jerryscript-project/jerryscript/pull/5204
  patch do
    url "https://github.com/jerryscript-project/jerryscript/commit/e8948ac3f34079ac6f3d6f47f8998b82f16b1621.patch?full_index=1"
    sha256 "ebce75941e1f34118fed14e317500b0ab69f48182ba9cce8635e9f62fe9aa4d1"
  end

  def install
    args = %w[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DJERRY_CMDLINE=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.js").write "print('Hello, Homebrew!');"
    assert_equal "Hello, Homebrew!", shell_output("#{bin}/jerry test.js").strip

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "jerryscript.h"

      int main (void)
      {
        const jerry_char_t script[] = "1 + 2";
        const jerry_length_t script_size = sizeof(script) - 1;

        jerry_init(JERRY_INIT_EMPTY);
        jerry_value_t eval_ret = jerry_eval(script, script_size, JERRY_PARSE_NO_OPTS);
        bool run_ok = !jerry_value_is_error(eval_ret);
        if (run_ok) {
          printf("1 + 2 = %d\\n", (int) jerry_value_as_number(eval_ret));
        }

        jerry_value_free(eval_ret);
        jerry_cleanup();
        return (run_ok ? 0 : 1);
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs libjerry-core libjerry-port libjerry-ext").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "JerryScript can add number"
  end
end
