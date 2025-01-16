class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.11.src.tar.gz"
  sha256 "a60c23dec95d10a2576265ce580f57869d5ac2471c4f4aca805addc9ea0fc9fe"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.22(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "175e41037e8ddcc19b274f9e2b167dc701c7a7ab5edc425c9a9a8455e8a9ec66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13075e13dfcbe79bb924c919b2eaf482c8dd23dc80d1be5f2cdcc52c8636f9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bdb68a40f283e409b1c2ce4820c54f5fd74877a2c05b9d9d35c39ade08b12fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1ee7aced05cc0affb137d42fe432919476e43451349a27246eb0e859f58d88"
    sha256 cellar: :any_skip_relocation, ventura:       "8a15c77eb0fbc50df3db4952dcaf86e9fa0e8b72c22aa4857317ee5849e44500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c503736f4ec712b65bb4d899d8a8fdd510027640f6988a58dc0f7035d8e5a864"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "std", "cmd"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~GO
      package main

      /*
      #include <stdlib.h>
      #include <stdio.h>
      void hello() { printf("%s\\n", "Hello from cgo!"); fflush(stdout); }
      */
      import "C"

      func main() {
          C.hello()
      }
    GO

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end
