class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-1.32.1.tgz"
  sha256 "f185e59d58f2c4f650fe32364834590654d6fe439bbc4e451a838f8ee9505da4"
  license "MIT"
  head "https://github.com/redocly/redocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe90b1ee90364e1be4a2ff9237d462f56a473b16a6ded882a2dd6d55471477b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe90b1ee90364e1be4a2ff9237d462f56a473b16a6ded882a2dd6d55471477b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe90b1ee90364e1be4a2ff9237d462f56a473b16a6ded882a2dd6d55471477b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef7836949a0f2267409e4fbfdf038195b9c3bd263f54a51eda338434a4f0a565"
    sha256 cellar: :any_skip_relocation, ventura:       "ef7836949a0f2267409e4fbfdf038195b9c3bd263f54a51eda338434a4f0a565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe90b1ee90364e1be4a2ff9237d462f56a473b16a6ded882a2dd6d55471477b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redocly --version")

    test_file = testpath/"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https://opensource.org/licenses/MIT
      servers: #ServerList
        - url: http://petstore.swagger.io:{Port}/v1
          variables:
            Port:
              enum:
                - '8443'
                - '443'
              default: '8443'
      security: [] # SecurityRequirementList
      tags: # TagList
        - name: pets
          description: Test description
        - name: store
          description: Access to Petstore orders
      paths:
        /pets:
          get:
            summary: List all pets
            operationId: list_pets
            tags:
              - pets
            parameters:
              - name: Accept-Language
                in: header
                description: 'The language you prefer for messages. Supported values are en-AU, en-CA, en-GB, en-US'
                example: en-US
                required: false
                schema:
                  type: string
                  default: en-AU
            responses:
              '200':
                description: An paged array of pets
                headers:
                  x-next:
                    description: A link to the next page of responses
                    schema:
                      type: string
                content:
                  application/json:
                    encoding:
                      historyMetadata:
                        contentType: application/json; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}/redocly lint --extends=minimal #{test_file} 2>&1")
  end
end
