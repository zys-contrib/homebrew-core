class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "445efe4264b3d067b05791b0b3fc12f0dfb2c15fd056db8234161e083622c95d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eadccaa4ab79bec3c1a73f25d39ccac5866d6e05a9e19df0ca5dd95f8d0d7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eadccaa4ab79bec3c1a73f25d39ccac5866d6e05a9e19df0ca5dd95f8d0d7bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eadccaa4ab79bec3c1a73f25d39ccac5866d6e05a9e19df0ca5dd95f8d0d7bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "08db18240cb3b9cb7d20889b6b73f6bce4dfd611da2fae92ea920ac511a7dec9"
    sha256 cellar: :any_skip_relocation, ventura:       "08db18240cb3b9cb7d20889b6b73f6bce4dfd611da2fae92ea920ac511a7dec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e1b2618d63e19d1d128f312cf27861264b149e5a014047f749e2302bbafcaf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}/mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http://127.0.0.1:8080"
    url_api_ledger = "http://127.0.0.1:3000"

    output = shell_output("#{bin}/mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http://127.0.0.1:8080", output
    assert_match "url-api-ledger:  http://127.0.0.1:3000", output
  end
end
