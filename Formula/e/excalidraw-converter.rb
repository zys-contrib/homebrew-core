class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "3bd151708755baed423e83d2875f3007ed065ba8acf5bf581b0157a88ce7c7bb"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a21367cdcda14775324c04177b3a5d53d33613b661d4807b3a2710b67f7c6e4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a21367cdcda14775324c04177b3a5d53d33613b661d4807b3a2710b67f7c6e4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a21367cdcda14775324c04177b3a5d53d33613b661d4807b3a2710b67f7c6e4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f89036fed3568c477cebc9e5eb7c897e7d6d3fa4efb5fecfa612195393df09e9"
    sha256 cellar: :any_skip_relocation, ventura:       "f89036fed3568c477cebc9e5eb7c897e7d6d3fa4efb5fecfa612195393df09e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d402b2e966566d4061e2e37cd4367939f365beff16bf057eacb2e81c9b096ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X diagram-converter/cmd.version=#{version}")
    bin.install_symlink "excalidraw-converter" => "exconv"
  end

  test do
    test_version = version

    resource "test_homebrew.excalidraw" do
      url "https://raw.githubusercontent.com/sindrel/excalidraw-converter/refs/tags/v#{test_version}/test/data/test_homebrew.excalidraw"
      sha256 "87e06e6b89a489fe01ccd06e51b8cc2b73bb51ff02e998d04eaa092a025d64e0"
    end

    resource("test_homebrew.excalidraw").stage testpath
    system bin/"excalidraw-converter", "gliffy", "-i", testpath/"test_homebrew.excalidraw", "-o",
testpath/"test_output.gliffy"
    assert_path_exists testpath/"test_output.gliffy"
    system bin/"exconv", "version"
  end
end
