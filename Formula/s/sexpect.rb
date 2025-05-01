class Sexpect < Formula
  desc "Expect for shells"
  homepage "https://github.com/clarkwang/sexpect"
  url "https://github.com/clarkwang/sexpect/archive/refs/tags/v2.3.14.tar.gz"
  sha256 "f6801c8b979d56eec54aedd7ede06e2342f382cee291beea88b52869186c557c"
  license "GPL-3.0-only"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sexpect --version")

    (testpath/"test.sh").write <<~SHELL
      #!/bin/sh

      export SEXPECT_SOCKFILE="#{testpath}/s.sock"

      sexpect sp -t 10 sleep 60
      sexpect c
      sexpect c
      sexpect c
      sexpect c
      sexpect ex -t 1 -eof
      sexpect w

      [ $? -eq 129 ]
    SHELL

    system "sh", "#{testpath}/test.sh"
  end
end
