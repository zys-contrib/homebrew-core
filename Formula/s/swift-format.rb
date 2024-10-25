class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/swiftlang/swift-format"
  url "https://github.com/swiftlang/swift-format.git",
      tag:      "600.0.0",
      revision: "65f9da9aad84adb7e2028eb32ca95164aa590e3b"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/swiftlang/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87797001883127b2279ca6c852090fd1fe2e268ada680161c1b2d86be113191e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38473895d6a806d2ebef3634f0a0f7fe9b10c733a6e538a33d2cd0bbead6bccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c7accbe185dba810d3fcd3d734705335e733359ccfa7a5d5ae0cbed480ac058"
    sha256 cellar: :any_skip_relocation, sonoma:        "10ebf6d40cc0c2d4d4cb3309e357e1b6a8d8b5991b5d30c479f3e81587e0c6cd"
    sha256 cellar: :any_skip_relocation, ventura:       "b12bf9258d6b73fd87d356978e93fa363b4239b50a37c8c2f16b313ad53c5364"
    sha256                               x86_64_linux:  "b350f38deae722dfb00b33610c82d17d6dcd0db3109f171adb56a3fafe0545a0"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build

  # Fix hang on Linux.
  # Remove with the next release.
  patch do
    url "https://github.com/swiftlang/swift-format/commit/5a1348bd9d08227b2af8a94e95bf2ebb1ca1817e.patch?full_index=1"
    sha256 "0b012627c97d077cbbbc5c9427bab8f6a5c03b150116b2370eaa43bb0b4d9454"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "swift-format"
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
