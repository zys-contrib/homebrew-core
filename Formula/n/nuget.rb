class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.13.1/nuget.exe"
  sha256 "10a2a3a2fd4604f21f7e5a74d1220c84c1ab8b2acbf8d81f1aa0270ba48454da"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0798dd072f3da3514d389f1c24b29b4fc87a459f92f63395f023a9ff8880617b"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~BASH
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    BASH
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
