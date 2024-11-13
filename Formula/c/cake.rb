class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "0c77a4a8626b1f6aa886e542026f33e2645bda7177e66c6ca1f60a6cf80b9bf0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a6f6297c1432c5e049759e27aa4d33cb62c38013feb4af1faee7ee204eea8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5843f082902a7684078be97fe4c3a2ceebb628329bc7f31205094c1c6a08d74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "388467b61b9804d9c6a1134e7a584e4cfb176fe5af16e754216e5706458d5a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "374a0d5c728f47ee1c3d5f832364caa3cfa70f4f0cdcae205cb046e17f6cb2c4"
    sha256 cellar: :any_skip_relocation, ventura:       "3cda4eb8413d6a4513d0bc085abfd89ed502c79efd71d903dff76e3930ed058c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4279a9392db8d794023860f45309380d7767b2f70cdf27398e5d0617ff160486"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/Cake", *args
    bin.install_symlink libexec/"Cake" => "cake"
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
