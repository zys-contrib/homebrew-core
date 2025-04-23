class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "0346b622ab1d4790e8adbe21256518e185fcc2bd379d5448b03662d7301e988c"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824c285217ad53865cbd4646cfab576d573a9137902e6cd0bd54a10f5062d4a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824c285217ad53865cbd4646cfab576d573a9137902e6cd0bd54a10f5062d4a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "824c285217ad53865cbd4646cfab576d573a9137902e6cd0bd54a10f5062d4a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "21621092de93dcafb685d92867fc272be625bd3b04814f7e3cd417b3cecc364a"
    sha256 cellar: :any_skip_relocation, ventura:       "da29569e16e7a5036fe09bdc633bc4c35d6481ee1abea8af6d10b5cec95d3b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc272c0bc6ca7b6a9d97d04a56051cc54528c0c4b6a64b8bee4db2250f8d5e81"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error: unable to identify git directory for repository", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
