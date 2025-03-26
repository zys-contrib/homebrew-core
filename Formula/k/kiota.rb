class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "96a2102a55bd57f84c7e76b9617f57f9b5a908fbe95018664844e6e6d60961fa"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ec67b831138e8c4e1651cba1b505a6edc1eec38a412944d0fc766e85c944611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce330b72dbefd98cf124054695b2c688c5957aa49aaead90b24caaf2f8ee416"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9e1ff804f61aad114c52c76114ebe478783fd6ab654e7c1f26b967d2c8d3b85"
    sha256 cellar: :any_skip_relocation, ventura:       "90ecf1f2b03dfe77963714993545055ca7dda786b06b84a45e36df4f2141fdac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08ef3dd31459fc84e25cad7fc3d5366a2aecf9bd1eda3f42ff30f66daf1e8fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1161e2c839b410877a01fc2065955d1e660b6731de757d18102cb1c9d68c5a8"
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
