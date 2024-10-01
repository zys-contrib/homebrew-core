class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "ad81a585e399093bcba2fab179bf8971fdebaf701758af20d84d21f24fdf1b50"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "745de860c67a18a6dd1d34544c87cc47c864172efb6c9ee517969b7ef7ed3232"
    sha256 cellar: :any,                 arm64_sonoma:  "e135623ddd3027c7b6610360398d6a22b17596a6950afa5273b2d659c7ae171a"
    sha256 cellar: :any,                 arm64_ventura: "0a9720a1dc27a48466bb8b2f587c86d4b4377cfcbea570bc50a2b649566a5ed7"
    sha256 cellar: :any,                 sonoma:        "2eaf552e501a229b9be772007baf5d5f999d6e60f4fb5351be64ed708a04c07d"
    sha256 cellar: :any,                 ventura:       "54e7503d43d6cdfb5315af0e80f6a027958a2ff7cca035065cc234f224266b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a7596a010b4144e221c8d04d981c78e4e26ad055109dffa56d6ba710e9ea1b"
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
