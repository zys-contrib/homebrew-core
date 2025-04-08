class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin/archive/refs/tags/2.2.0.tar.gz"
  sha256 "6b30d73e4562723b9541f82d55b56b9fa22d1cb2aae421ea95b08507c4d0d09b"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "258566d0b50dc04657c8a9c737f4adf331a450e9a87fbc49343a2f045a11a431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0118eb40f7b30e8c5b38964a867239923c91da3e2f972577dd82358fc9fe3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b6d91ba83529e71b3f1904e3c7bbc111e620b35bba3c2a1f3b08d1779293f2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f45df4b3e80f1c8336cd9839fe608668d46c38f6abe6efeac1ea0820ac4ea838"
    sha256 cellar: :any_skip_relocation, ventura:       "33a3da5c279a5d0e17d6911bbebdcbdefcd882e2e07c960f736b58233735f80b"
  end

  depends_on "gradle" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    suffix = Hardware::CPU.intel? ? "X64" : "Arm64"
    system "gradle", "--no-daemon", "linkReleaseExecutableMacos#{suffix}", "preparePlugin"
    bin.install "build/bin/macos#{suffix}/releaseExecutable/xcode-kotlin.kexe" => "xcode-kotlin"
    share.install Dir["build/share/*"]
  end

  test do
    output = shell_output(bin/"xcode-kotlin info --only")
    assert_match(/Bundled plugin version:\s*#{version}/, output)
    assert_match(/Installed plugin version:\s*(?:(?:\d+)\.(?:\d+)\.(?:\d+)|none)/, output)
    assert_match(/Language spec installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB init installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB Xcode init sources main LLDB init:\s*(?:Yes|No)/, output)
  end
end
