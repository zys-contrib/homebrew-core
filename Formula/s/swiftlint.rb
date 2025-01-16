class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.58.2",
      revision: "eba420f77846e93beb98d516b225abeb2fef4ca2"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "956e860516741c967673bc13658f6f7fdeb6e50eb466940b47c5acfbc7ba7b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a4c23ccfa7a25ee13441b0bafc46ba6ba6fe344553d1b144ae9cb6dbe8b2cdf"
    sha256 cellar: :any,                 arm64_ventura: "853f96cd9ca8f9356708aa6ef17f8ca9690167923cac23c5ed9eb3b7dafc8cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc52151499acbf8f5fec2237862bde4c40754a9f50155af82e1cd6f301fcd091"
    sha256 cellar: :any,                 ventura:       "ba07bcc9302547f20a2b09139f4975bff73d64f13bfd3550a400c7171390d812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fc3b510739f75b2c71e53e8e80976652b5d76f9fec18ea8b17597b573c6a9c"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
    generate_completions_from_executable(bin/"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=5 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
