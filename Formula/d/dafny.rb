class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "bd643ae9cd5b697505ca3682fa4d15238c6746701eaa1eeba4c541006674da40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a36bf3e4ca3d330259682a45b8e2819ff8c77c64268038675cab30ee2757f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d0c2d698efa882dc35316a259c2d1bca1f3814f2b143f01e1088e3a4b10c77b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b780a11bcc50e5c26ee52e3ea912be50caf1d0404afe9fb0f6bd3d55b3b48fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5797f4585a7641abb8e04c9ff93410bb9efed682344b772edd313ff6622a2dd"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => [:build, :test]

  depends_on "dotnet@8"
  depends_on "z3"

  def install
    # Use our `gradle` to build rather than wrapper which uses its own copy
    rm("Source/DafnyRuntime/DafnyRuntimeJava/gradlew")
    inreplace "Source/DafnyRuntime/DafnyRuntime.csproj", 'Command="./gradlew ', 'Command="gradle '

    system "make", "exe"
    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@8"].opt_bin}/dotnet" "#{libexec}/Dafny.dll" "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        var i: nat :| true;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny verify #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nhello, Dafny\n",
                  shell_output("#{bin}/dafny run #{testpath}/test.dfy")

    ENV["JAVA_HOME"] = Language::Java.java_home
    assert_match(/^\nDafny program verifier finished with 1 verified, 0 errors\n(.*\n)*hello, Dafny\n$/,
                 shell_output("#{bin}/dafny run --target:java #{testpath}/test.dfy"))
  end
end
