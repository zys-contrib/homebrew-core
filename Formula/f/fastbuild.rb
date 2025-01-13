class Fastbuild < Formula
  desc "High performance build system for Windows, OSX and Linux"
  homepage "https://fastbuild.org/"
  url "https://github.com/fastbuild/fastbuild/archive/refs/tags/v1.14.tar.gz"
  sha256 "07ebc683634aef24868f3247eedaf6e895869fa4f5b70e26a1d0c7ec892dfbc3"
  license "Zlib"

  resource "bootstrap-fastbuild" do
    on_macos do
      url "https://fastbuild.org/downloads/v1.13/FASTBuild-OSX-x64%2BARM-v1.13.zip"
      sha256 "290e60e0c3527c3680c488c67f1c7e20ca7082d35e38664cd08ca365d18b46fe"
    end
    on_linux do
      url "https://fastbuild.org/downloads/v1.13/FASTBuild-Linux-x64-v1.13.zip"
      sha256 "0aede5c4963056bd90051626e216ca4dfcc647c43a082fab6f304f2d4b083d6e"
    end
  end

  def install
    resource("bootstrap-fastbuild").stage buildpath/"bootstrap"
    fbuild = buildpath/"bootstrap/fbuild"
    chmod "+x", fbuild
    # Fastbuild doesn't support compiler detection, see
    # https://github.com/fastbuild/fastbuild/issues/511
    # and https://fastbuild.org/docs/functions/compiler.html
    inreplace "External/SDK/GCC/GCC.bff", /(?<=#define )USING_GCC_9/, "USING_GCC_11" if OS.linux?

    os = OS.mac? ? "OSX" : "Linux"
    arch = Hardware::CPU.arm? ? "ARM" : "x64"
    host = "#{arch}#{os}-Release"

    cd "Code" do
      system fbuild, "All-#{host}"
    end
    %w[FBuild FBuildWorker].each do |t|
      bin.install "tmp/#{host}/Tools/FBuild/#{t}/#{t.downcase}"
    end
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main(void) {
        printf("Hello\\n");
        return 0;
      }
    C
    (testpath/"fbuild.bff").write <<~BFF
      .CompilerInputPattern = '*.c'
      .Compiler = '#{ENV.cc}'
      .CompilerOptions = '-c "%1" -o "%2"'
      .Linker = '#{ENV.cc}'
      .LinkerOptions = '"%1" -o "%2"'
      ObjectList( 'HelloWorld-Lib' )
      {
        .CompilerInputPath  = '\\'
        .CompilerOutputPath = '\\'
      }
      Executable('HelloWorld')
      {
        .Libraries = { 'HelloWorld-Lib' }
        .LinkerOutput  = 'hello'
      }
      Alias('all') { .Targets = { 'HelloWorld' } }
    BFF
    system bin/"fbuild"
    assert_equal "Hello", shell_output("./hello").chomp
  end
end
