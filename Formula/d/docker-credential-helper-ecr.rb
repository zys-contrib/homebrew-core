class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "dd97ebe79fcc488496cb6e5b2ad9f8a79b5105018c6ee02be9f80cc0df0f4ad7"
  license "Apache-2.0"
  head "https://github.com/awslabs/amazon-ecr-credential-helper.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fedaf37d87aae03d6e661d21a997d2913dd09e77754f0574ad6936405fcd1597"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fedaf37d87aae03d6e661d21a997d2913dd09e77754f0574ad6936405fcd1597"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fedaf37d87aae03d6e661d21a997d2913dd09e77754f0574ad6936405fcd1597"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a7e351e896541eb5048280a91cfbfc0888ecdc9f0a6111c2d18391d4dd7366f"
    sha256 cellar: :any_skip_relocation, ventura:       "4a7e351e896541eb5048280a91cfbfc0888ecdc9f0a6111c2d18391d4dd7366f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36baad59d47edd5adb202e9c87fab1c00bc7c58c09d2bd3e3cdea6d2e24e7bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b885a402893475b5e4fb09e712a50af51a7ad9f1edfae2adaa782f8444fc373"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    (buildpath/"GITCOMMIT_SHA").write tap.user
    system "make", "build"
    bin.install "bin/local/docker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match(/^Usage: .*docker-credential-ecr-login/, output)
  end
end
