class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "80ed050ffe2b1dbd474515ffa417106477de4fbbccb1fbbf4505edb49d33c2ea"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "067c01469febba3aadffa360edbea876e01cdd55ff0a4c297efdac38d81d4d59"
    sha256 cellar: :any,                 arm64_ventura:  "e7d56830ec23f8df074236e7128f51eb63873bd97d3458f86e59e7c6b1bf9da7"
    sha256 cellar: :any,                 arm64_monterey: "375769bfc126d426cd6f1c34cb6eb63087b9e1304a0aed10aed26b0788eff131"
    sha256 cellar: :any,                 sonoma:         "24dc0f48be8faf8b17ab3e678c3dc11b259960b712ceb9f5d702b38b27624d2f"
    sha256 cellar: :any,                 ventura:        "c4c2c85559dc61553b902c946c791ac47e734e2049c4027fda3b9fcae50eb4a3"
    sha256 cellar: :any,                 monterey:       "0bd128afbb14f3f42a9a705406cb2c4e8e9657efad3afccc763d3303ae24f5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f10aef1a5f9c742be9297d11c28f2dd3e32aa3e202d166d58532ea87530c0f0"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture arm64:
      #   "std::exception_ptr::__from_native_exception_pointer(void*)", referenced from:
      #       std::exception_ptr std::make_exception_ptr[abi:ne180100]<antlr4::NoViableAltException>...
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    args = %w[
      -DAUTO_UPDATE_GRAMMAR=0
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    db_path = testpath/"testdb/"
    cypher_path = testpath/"test.cypher"
    cypher_path.write <<~EOS
      CREATE NODE TABLE Person(name STRING, age INT64, PRIMARY KEY(name));
      CREATE (:Person {name: 'Alice', age: 25});
      CREATE (:Person {name: 'Bob', age: 30});
      MATCH (a:Person) RETURN a.name AS NAME, a.age AS AGE ORDER BY a.name ASC;
    EOS

    output = shell_output("#{bin}/kuzu #{db_path} < #{cypher_path}")

    expected_1 = <<~EOS
      ┌────────────────────────────────┐
      │ result                         │
      │ STRING                         │
      ├────────────────────────────────┤
      │ Table Person has been created. │
      └────────────────────────────────┘
    EOS
    expected_2 = <<~EOS
      ┌────────┬───────┐
      │ NAME   │ AGE   │
      │ STRING │ INT64 │
      ├────────┼───────┤
      │ Alice  │ 25    │
      │ Bob    │ 30    │
      └────────┴───────┘
    EOS

    assert_match expected_1, output
    assert_match expected_2, output
  end
end
