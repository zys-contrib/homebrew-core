class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "cec08c3256b072cf6aa1408aa4e0a111baad4a069601fdc7502119afe61077ee"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b6743620830cf863fc799cb8cd09f454f1f4d5b660d82fc03cc897b0fc668870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c65ecc87b57da0ddcd9bd81a61270c4b8f37cda54e2b54bfa1ad554529dd411"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c65ecc87b57da0ddcd9bd81a61270c4b8f37cda54e2b54bfa1ad554529dd411"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c65ecc87b57da0ddcd9bd81a61270c4b8f37cda54e2b54bfa1ad554529dd411"
    sha256 cellar: :any_skip_relocation, sonoma:         "e04ac808f686150e9434d4d180b1b90584e054e17f41800dd46fbce391b36e75"
    sha256 cellar: :any_skip_relocation, ventura:        "e04ac808f686150e9434d4d180b1b90584e054e17f41800dd46fbce391b36e75"
    sha256 cellar: :any_skip_relocation, monterey:       "e04ac808f686150e9434d4d180b1b90584e054e17f41800dd46fbce391b36e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29b5c65f9f4da17add6bea4f885c6efab4d4028950268276f08d515d9563ac8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"dalfox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox version 2>&1")

    url = "http://testphp.vulnweb.com/listproducts.php?cat=123&artist=123&asdf=ff"
    output = shell_output("#{bin}/dalfox url \"#{url}\" 2>&1")
    assert_match "Finish Scan!", output
  end
end
