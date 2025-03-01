class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "07deb4a988df8c92340101bcf7aca959f9a48ffba6a0558fc778ceca5edad8fa"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d7a64dcf8838d437cb5047ca9c212863188d2b3c39d8b18714eb303dec9c2f9b"
    sha256 arm64_sonoma:  "d84043485ee4b3dba82128b13f3cded4ba37f6de6fdfed00456c16c2997f791f"
    sha256 arm64_ventura: "9f5b0d6f06532409e77b4298639aa3dd450cc97c5234a705213fa75ea61851c3"
    sha256 sonoma:        "ff3d6a18a6bdb79c5838f2e36d309857ea3a87d94fd32b48191efd13ea885744"
    sha256 ventura:       "4265e34c28ef5e60332d468f8b1fced5e0f60c1bbfb8ff179ae4195a3aeeb93f"
    sha256 x86_64_linux:  "f0eccae09a0bf131a7e51e2854da2d256a0396238e195eb871f80fa80fd65a08"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~GOP
      println("Hello World")
    GOP

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop 2>&1")

    (testpath/"go.mod").write <<~GOMOD
      module hello
    GOMOD

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end
