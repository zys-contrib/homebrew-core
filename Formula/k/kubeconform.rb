class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "3d38b9f3f8c75a2ac5917ab2dda0a6a89a581a75ed755aec698e931611979223"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60f67e00d123b27a84f45960932406cc2789e3f1e60e82d62af19d420e64fba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "444c69b80852fb700fbb6107b62db33554c1d03c25640f744fd96d0ad17f8346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35f55693111b1581c20dd918079a05e218a8bd80946eb7cbf56dfa7db8ccd475"
    sha256 cellar: :any_skip_relocation, sonoma:         "410800845c03130e2f16e61192f83c5ce459593cfc400e599d0a353012eac7dd"
    sha256 cellar: :any_skip_relocation, ventura:        "24fea257f591d7f8697f9bf03438fb1d9d4cd3a7615955104c058ae46c010666"
    sha256 cellar: :any_skip_relocation, monterey:       "6091f3e33fed070093d7b6736ffde68d57ca4a04357e0b2332798b6dda2f4519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe34d5e12501453ad6f6fff8a7cabcaffad5caec315304f7dfe60d6685807a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)
  end
end
