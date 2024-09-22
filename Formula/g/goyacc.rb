class Goyacc < Formula
  desc "Parser Generator for Go"
  homepage "https://pkg.go.dev/modernc.org/goyacc"
  url "https://gitlab.com/cznic/goyacc/-/archive/v1.0.3/goyacc-v1.0.3.tar.bz2"
  sha256 "a999dd35759dfa35cc2cff70b840db0cd41443ef7aff7b090ac170731e6a6c6c"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{
      package main
      %}

      %union { val int }
      %token <val> NUM
      %type <val> expr term factor

      %%
      expr : expr '+' term { $$ = $1 + $3; }
          | term          { $$ = $1; }
          ;
      term : term '*' factor { $$ = $1 * $3; }
          | factor          { $$ = $1; }
          ;
      factor : '(' expr ')'  { $$ = $2; }
            | NUM           { $$ = $1; }
            ;
      %%
    EOS

    system bin/"goyacc", "-o", "test.go", "test.y"
    assert_match "package main", (testpath/"test.go").read
  end
end
