class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "1349790b2828a66f2f431fc34cfdd0499dc7ab159837e64a09b567c5f32523f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e000966c011ae82572a14fe24a554ba75a48babd1c3dc9dfea76932cce543b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e000966c011ae82572a14fe24a554ba75a48babd1c3dc9dfea76932cce543b0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e000966c011ae82572a14fe24a554ba75a48babd1c3dc9dfea76932cce543b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7960f117db901c57acaa881bbfc28afe0577376944b7aac075ad718b311b8863"
    sha256 cellar: :any_skip_relocation, ventura:       "7960f117db901c57acaa881bbfc28afe0577376944b7aac075ad718b311b8863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90ac82e49f93aecf5662833e3eb884ec5f99171ddcfb710fe1864d1f1c5bebd"
  end

  depends_on "go" => :build

  def install
    cd "cmd/energy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/energy cli -v")
    assert_match "CLI Current: v#{version}", output
    assert_match "CLI Latest : v#{version}", output

    assert_match "https://energy.yanghy.cn", shell_output("#{bin}/energy env")
  end
end
