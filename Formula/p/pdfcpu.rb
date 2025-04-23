class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "a07cc50446ef6526fa26d5fe2c9e207724971e0b6917f3d70680ec39cfc53aec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "014530fdc50251f13f51c0dfb6e40c36e666116ba289390eff455f1821bfc057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "014530fdc50251f13f51c0dfb6e40c36e666116ba289390eff455f1821bfc057"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "014530fdc50251f13f51c0dfb6e40c36e666116ba289390eff455f1821bfc057"
    sha256 cellar: :any_skip_relocation, sonoma:        "69a8c9d8147c1ae7219e8ab2d376b82804d9ff5671bf3b83406b5f45a2a18374"
    sha256 cellar: :any_skip_relocation, ventura:       "69a8c9d8147c1ae7219e8ab2d376b82804d9ff5671bf3b83406b5f45a2a18374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ecf563884d2812c018acb22c74211894aceeba1e73de1cb701c07ea2e5f9cc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    config_file = if OS.mac?
      testpath/"Library/Application Support/pdfcpu/config.yml"
    else
      testpath/".config/pdfcpu/config.yml"
    end
    # basic config.yml
    config_file.write <<~YAML
      reader15: true
      validationMode: ValidationRelaxed
      eol: EolLF
      encryptKeyLength: 256
      unit: points
    YAML

    assert_match version.to_s, shell_output("#{bin}/pdfcpu version")

    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
