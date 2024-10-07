class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "39d7b64a6da36fd34ad887159a89640c7f2bd3bc921b8c787480374f04628f66"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "66bdf5f4b892ec08b15dc8261b949c0ec0ced60e76a3e335d1a0d15eb4a67bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6d3834ef9059ec491aa9ac378b0bf4917167c88b0d4296061cdc5c06bd6a799"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c2e623027cd4168564aab495ea0bcedf87b932b0c158dceaa2bd517e60a30db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fda10609af91d6a2b002826836ca5c0d5573ab9d6de9ec258e1127fc6259e10"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eaa149956c37d895ad1d655726c08117ad0ece152d30027c5f929d8c5ed12c0"
    sha256 cellar: :any_skip_relocation, ventura:        "845ca55139c474e03109361fcb87b5a67eac1d4ef05bc147c0b59891ce8afb4e"
    sha256 cellar: :any_skip_relocation, monterey:       "ec703101371a665c8e625ba124ba3d15ade91e10eb144060b07f02987090cb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827b2e9eaf626071c263ba62d7a5ceb14a79d613561844b31b9a152b58e3e2db"
  end

  depends_on "dotnet"

  # compiler version mismatch patch, upstream pr ref, https://github.com/microsoft/kiota/pull/5548
  patch do
    url "https://github.com/microsoft/kiota/commit/13f564c59a29db31339e587d1d788fba433978fc.patch?full_index=1"
    sha256 "5c026bbf483d9e8053c6b89d9815308dad1ac27cc8bb16f711ce5b6648a80cf8"
  end

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args

    (bin/"kiota").write_env_script libexec/"kiota",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
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
