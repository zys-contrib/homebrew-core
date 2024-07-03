class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.367.14.tar.gz"
  sha256 "6b38708c8c451eb2abbc44f7895311a31ef1e1dc4ba2273fa66ce119ffdab932"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5688956fa97ad7eace86f4527aa4166ab01e57856cfdb7e42e3ccacdc4a690fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24d80f6d91599160533b524dc3ce1574ec90d14a614951b48d76ecb72925387b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "956ade7f0f17c0a1888b1bef50d6c5b8e3d8f1adc7b8fe1ded33dd1089949a4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "09624a8ced43d1844bc1f8af4cd18b53e2d4cc3becdde0a595880e2fc85d675a"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce52f72f0fc6b6cb9fe8113522d5b7f65ea48fcc1fa727b1a9d7bd8df96d27a"
    sha256 cellar: :any_skip_relocation, monterey:       "8412d60b4321e4870ec276a25c2d94102926b835b507ecae5dad82ec0fc710d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cbd15e896ccd49710c0616ce5d5796b53485ecf5119067c4b1c90df14a35941"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
