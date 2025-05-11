class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "4e4a8617003438d5c8f4f0e5afd08808070757091781ee28d09a55f3f9eddd2c"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df12d36c7c6313ede24c95d86374cb031d4a6575993f06a4c334c3a2d954563e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df12d36c7c6313ede24c95d86374cb031d4a6575993f06a4c334c3a2d954563e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df12d36c7c6313ede24c95d86374cb031d4a6575993f06a4c334c3a2d954563e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fad18b4e2380047f9dc48c1a736d16c8bab239476b926ceedff4044399bacfa"
    sha256 cellar: :any_skip_relocation, ventura:       "6fad18b4e2380047f9dc48c1a736d16c8bab239476b926ceedff4044399bacfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f97cb8c7008d6acdeb3e668bf764fd2a1a380e156aab83b3b8136916263fb8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
