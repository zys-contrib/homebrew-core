class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "ca927a4cd531e79f84e9b57c3ac8a5a5b125f704759a4f435fb54b31d982e448"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3476963b4fd86757acb25fb6dcf992c86899d64ccb01e8ca928a242c29d3ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3476963b4fd86757acb25fb6dcf992c86899d64ccb01e8ca928a242c29d3ccf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3476963b4fd86757acb25fb6dcf992c86899d64ccb01e8ca928a242c29d3ccf"
    sha256 cellar: :any_skip_relocation, sonoma:        "62705ae3adbe31d81d9aeb7abc41de8b53e4f5d1a9b231dc50cb0cf90e19077a"
    sha256 cellar: :any_skip_relocation, ventura:       "62705ae3adbe31d81d9aeb7abc41de8b53e4f5d1a9b231dc50cb0cf90e19077a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73fea410c55db0c58083b50221c744d918a1006e913d4e4edaa5af1621a09e86"
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
