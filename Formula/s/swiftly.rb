class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.0.0",
      revision: "a9eecca341e6d5047c744a165bfe5bbf239987f5"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc28dabc0146237e42d87249c82ab5de387cd086d42357319fa3ad0890e5918f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ad3dcdfd507f2a0ba89e9872761c41a77b6b963e0847f19093bc4c725d3097"
    sha256 cellar: :any,                 arm64_ventura: "65f03c9c0a746e983762be67e249b28b283e7db72c8b92fad0d91e28697d5a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6e40c56ca0228978f8c16ae882f562b5a9c4110d6216e3bb57951fd1efb3f7e"
    sha256 cellar: :any,                 ventura:       "c68111469617b923dcfc4888d6a1855813935ea90fb3e1b8f2ed64cec6929796"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "zlib"

  on_sonoma :or_older do
    depends_on xcode: ["15.0", :build]
  end

  on_linux do
    depends_on "libarchive"
  end

  def install
    args = %w[
      --configuration release
      --disable-sandbox
      --product swiftly
    ]
    if OS.linux?
      args += %W[
        --static-swift-stdlib
        -Xswiftc -I#{HOMEBREW_PREFIX}/include
        -Xlinker -L#{HOMEBREW_PREFIX}/lib
      ]
    end
    system "swift", "build", *args

    bin.install ".build/release/swiftly"
  end

  test do
    # Test swiftly with a private installation
    swiftly_bin = testpath/"swiftly"/"bin"
    mkdir_p swiftly_bin
    ENV["SWIFTLY_HOME_DIR"] = testpath/"swiftly"
    ENV["SWIFTLY_BIN_DIR"] = swiftly_bin
    ENV["SWIFTLY_TOOLCHAINS_DIR"] = testpath/"swiftly"/"toolchains"
    system bin/"swiftly", "init", "--assume-yes", "--no-modify-profile", "--skip-install"
  end
end
