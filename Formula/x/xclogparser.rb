class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.40.tar.gz"
  sha256 "b8bd40342ab3918c00ccc174e929a05de2a3cd196dff9ae3ef3dc8a21e0413b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2af489ea40d0e2ea3d490c151137cc74992e17d9e5d4ea842efe37bb5c3c83f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e19d4da37201c378b92ffd06a507898d63d294edd235084fc5e5122348914975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1228c821cb757a23ffc94f27cabe4d8096cd2d317328d2155f7b601e9f6858c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9013e93d887c83d7c4148e225185aafcce876cd1e95ae640d43056520177ccaf"
    sha256 cellar: :any_skip_relocation, ventura:        "d6d2526690a5598b53da6b34361276063540ac8f376600f52d61bc8884364211"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab8fc7785b340892fc87599aeffe8523a60e5b0abb45a3a23a9d70b4da28261"
    sha256                               x86_64_linux:   "8709b44656e8e3f3c943627d72a49e92d99e3d0f487cc1552e5d7d22cf65c313"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"
  uses_from_macos "zlib"

  # patch to use linuxbrew zlib, upstream pr ref, https://github.com/1024jp/GzipSwift/pull/71
  on_linux do
    patch :DATA
  end

  # version patch, upstream pr ref, https://github.com/MobileNativeFoundation/XCLogParser/pull/223
  patch do
    url "https://github.com/MobileNativeFoundation/XCLogParser/commit/430107e1e6ec9d54ddaa301d64596c7311f7c966.patch?full_index=1"
    sha256 "5a4613af2ead387887e508032673d4fbb9afbf66fd919e9b16cf42b5b453218d"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/xclogparser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xclogparser version")

    # skip tests for linux build and sequoia macos build due to the test file issue
    return if OS.linux? || (OS.mac? && MacOS.version == :sequoia)

    resource "homebrew-test_log" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2024.04.14/test.xcactivitylog"
      sha256 "3ac25e3160e867cc2f4bdeb06043ff951d8f54418d877a9dd7ad858c09cfa017"
    end

    resource("homebrew-test_log").stage(testpath)
    output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    assert_match "Target 'helloworldTests' in project 'helloworld'", output
  end
end

__END__
diff --git a/Package.resolved b/Package.resolved
index 900fb44..cc4b2bc 100644
--- a/Package.resolved
+++ b/Package.resolved
@@ -11,12 +11,12 @@
         }
       },
       {
-        "package": "Gzip",
+        "package": "GzipSwift",
         "repositoryURL": "https://github.com/1024jp/GzipSwift",
         "state": {
           "branch": null,
-          "revision": "ba0b6cb51cc6202f896e469b87d2889a46b10d1b",
-          "version": "5.1.1"
+          "revision": "29f62534648e6334678b6d7b14c6f7e618715944",
+          "version": null
         }
       },
       {
diff --git a/Package.swift b/Package.swift
index 98f46e7..068b3db 100644
--- a/Package.swift
+++ b/Package.swift
@@ -11,7 +11,7 @@ let package = Package(
         .library(name: "XCLogParser", targets: ["XCLogParser"])
     ],
     dependencies: [
-        .package(url: "https://github.com/1024jp/GzipSwift", from: "5.1.0"),
+        .package(url: "https://github.com/1024jp/GzipSwift", revision: "29f62534648e6334678b6d7b14c6f7e618715944"),
         .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .exact("1.3.3")),
         .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
         .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
