class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "c999f61e23c253d567f49c20ac4dc5d4e3187515dc7e1a42ac0482cb7124730a"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9f4ff91762e0a8596c519d9da72ecde45fb0934ec3231fd57c565f47774339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f949c7f40ee3ac1fbd11cfa5756612389df72f253326a32c52683f080439c3fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cc24413468536c8e67c24f850276ef62662af1d1ca94bf8f8f1b7e24af21086"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff834734786c6b77dc73c13553bac4ed73acb0e1fb6e521ab4a2075dae255581"
    sha256 cellar: :any_skip_relocation, ventura:       "c2c76422fee2f9d19715c56b872adfb26e1c2e4c196d6363a72a90d6496b3d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee14a036530eca47400b0f825adc8518c4a499fa1bdc781998a748ed6446ec5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/internal/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/internal/version.commit=#{tap.user}
      -X github.com/arduino/arduino-cli/internal/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"arduino-cli", "completion")
  end

  test do
    system bin/"arduino-cli", "sketch", "new", "test_sketch"
    assert_path_exists testpath/"test_sketch/test_sketch.ino"

    assert_match version.to_s, shell_output("#{bin}/arduino-cli version")
  end
end
