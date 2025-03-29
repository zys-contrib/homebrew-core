class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.0.0",
      revision: "a9eecca341e6d5047c744a165bfe5bbf239987f5"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  # On Linux, SPM can't find zlib installed by brew.
  # TODO: someone who cares: submit a PR to fix this!
  depends_on :macos

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "zlib"

  on_linux do
    depends_on "libarchive"
  end

  def install
    system "swift", "build", "--configuration", "release", "--product", "swiftly", "--disable-sandbox"
    bin.install ".build/release/swiftly"
  end

  test do
    swiftly_bin = testpath/"swiftly"/"bin"
    mkdir_p swiftly_bin
    ENV["SWIFTLY_HOME_DIR"] = testpath/"swiftly"
    ENV["SWIFTLY_BIN_DIR"] = swiftly_bin
    system bin/"swiftly", "init", "--assume-yes", "--no-modify-profile"
    system bin/"swiftly", "install", "latest", "--use"
    (testpath/"main.swift").write <<~EOS
      @main
      struct HelloSwiftly {
        static func main() {
          print("Hello Swiftly!")
        }
      }
    EOS
    system swiftly_bin/"swiftc", "main.swift", "-parse-as-library"
    assert_match "Hello Swiftly!", shell_output("./main").chomp
  end
end
