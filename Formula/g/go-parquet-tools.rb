class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.25.12.tar.gz"
  sha256 "a34e545858754ac7ba6e03e0ae51d91dacd21597f59a1fc4c80581ac59b37df1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62082925811d7afb270bb749409a2cf3521d87f6ad38223355d366fd69b38baf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62082925811d7afb270bb749409a2cf3521d87f6ad38223355d366fd69b38baf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62082925811d7afb270bb749409a2cf3521d87f6ad38223355d366fd69b38baf"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea7e86a5e01af18e7462964fafc4a0d635f59da2d0d49a46a6dced3609013bd"
    sha256 cellar: :any_skip_relocation, ventura:       "aea7e86a5e01af18e7462964fafc4a0d635f59da2d0d49a46a6dced3609013bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8659d6a678a44c0dfabdfdb12d4d4c399004abd2ebeb7ef3d745d31d7a47a104"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=Homebrew
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
    assert_match "name=Parquet_go_root", output
  end
end
