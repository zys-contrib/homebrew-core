class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  # Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.24.1.tar.gz"
    sha256 "7adb5bb3b3c2c4f4fdc980a9a13df8fbf3526a82b5c37dd9cf2ed29de56a4683"

    # Fix `.pc` file generation. Remove at next release.
    # https://github.com/tree-sitter/tree-sitter/pull/3745
    patch do
      url "https://github.com/tree-sitter/tree-sitter/commit/079c69313fa14b9263739b494a47efacc1c91cdc.patch?full_index=1"
      sha256 "d2536bd31912bf81b2593e768159a31fb199fe922dafb22b66d7dfba0624cc25"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2eaa48e6096083583b0ac1d7f557863968c661f608f313b8233b1d214a43f36b"
    sha256 cellar: :any,                 arm64_sonoma:  "43b9e55c338b44aee21c9e011c1897beffedcfcadaa7372f6296e48722ebfdf2"
    sha256 cellar: :any,                 arm64_ventura: "2dec7a04b253a6e3cf06082d7d47cad43dd0fc54e75943cb3c7a9933a72a0979"
    sha256 cellar: :any,                 sonoma:        "aafe252d77a3c013e9d383a67fb15fbbfc7af789f7e5ac58423a155293e033d0"
    sha256 cellar: :any,                 ventura:       "f69af07cd6d6363852fad02d5b367ffa46a672ffeba04b7a1cd8fc0065519508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78450dab80b341cf87cd33e873f194a48ba4568ced4e938bb58c3c45f5a5fcbe"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # a trivial tree-sitter test
    assert_equal "tree-sitter #{version}", shell_output("#{bin}/tree-sitter --version").strip

    # test `tree-sitter generate`
    (testpath/"grammar.js").write <<~EOS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    EOS
    system bin/"tree-sitter", "generate", "--abi=latest"

    # test `tree-sitter parse`
    (testpath/"test/corpus/hello.txt").write <<~EOS
      hello
    EOS
    parse_result = shell_output("#{bin}/tree-sitter parse #{testpath}/test/corpus/hello.txt").strip
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result)

    # test `tree-sitter test`
    (testpath/"test"/"corpus"/"test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system bin/"tree-sitter", "test"

    (testpath/"test_program.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <tree_sitter/api.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
        // Because we have no language libraries installed, we cannot
        // actually parse a string successfully. But, we can verify
        // that it can at least be attempted.
        const char *source_code = "empty";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );
        if (tree == NULL) {
          printf("tree creation failed");
        }
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    EOS
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
