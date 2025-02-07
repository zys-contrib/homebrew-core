class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "1ca7eba6265dd3af133707a794be6898e69e61522b9f506166d18191525607ae"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6322628e8c4bbabdac5b42d56313f3d6e4fb919849b7d65922d136a94182fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65862d8407acba89eea064be73116ded6583e562284e49fd8926e8764117f0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1416db0a5095b0c62b4a05fbdae656a2c5e86a22134d46a89b9a911e84ee3b5b"
    sha256 cellar: :any_skip_relocation, ventura:       "9832f17b4de38c08b2fa2cb66857cbf82b6d655a739c3f4fd0623d4fd9c333d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e16158020a935e21886ae0bac3b0bfbbd25ad861f9839d70a5d450f93e5450"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
    ]
    args << "-p:Version=#{version}" if build.stable?

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args
    (bin/"kiota").write_env_script libexec/"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go          Stable", info_output
    assert_match "Python      Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match "apisguru::github.com                            GitHub v3 REST API", search_output
  end
end
