class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.34.tar.gz"
  sha256 "831450c20115a2446513629b71597ae1dd6d81d185cb65a3d49fba5d1c7c220d"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c8b686b3371f819974730d1a917a718fc096c6a655031861bd7c225c6114bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1c8b686b3371f819974730d1a917a718fc096c6a655031861bd7c225c6114bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1c8b686b3371f819974730d1a917a718fc096c6a655031861bd7c225c6114bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b02054947f56d5733b292a6302016632922e3fc297e22718820857e2c33c0664"
    sha256 cellar: :any_skip_relocation, ventura:       "b02054947f56d5733b292a6302016632922e3fc297e22718820857e2c33c0664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a422793a7e0602096a7fbc5f5a547f1e4dc9442a25a34fe4b46022b4f33f4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
