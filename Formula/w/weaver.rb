class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/refs/tags/1.1.7.tar.gz"
  sha256 "8d53fbcd1283cea93532d8b301f11353bd7634d865c8148df3bc3f65d0447a19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03bf5b5e76c95197ccca7802d1641cb0718e032ec33dc1d230654f9d069f9bab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d140adbcced8f4dc5c9435f87e1a046d54c5da572375d094720007cce5379cf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae444f345f51ceb5fb13781192bbe2b0ad90b04ed84441b6f7a715018072db09"
    sha256 cellar: :any_skip_relocation, sonoma:        "13b24f6318027d5f943198879212247b5dd10223d030e42dc68760c4a9e915f5"
    sha256 cellar: :any_skip_relocation, ventura:       "387c5ae8c6e1aae6f230b3e36102032b02dec9b69176c05ef813399f849bd791"
  end

  depends_on xcode: ["11.2", :build]
  depends_on :macos # needs macOS CommonCrypto

  uses_from_macos "swift"

  conflicts_with "service-weaver", because: "both install a `weaver` binary"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system bin/"weaver", "version"
  end
end
