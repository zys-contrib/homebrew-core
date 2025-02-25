class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-1.31.0.tgz"
  sha256 "13928da058d1499baed1364e13dfc8b604c47a9dfb109395aa3aa0e15cc53d80"
  license "MIT"
  head "https://github.com/redocly/redocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89e46ef59aad7beba174706b3aa93cf22b9b45b7923cea01b5904f3cd3ddc989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e46ef59aad7beba174706b3aa93cf22b9b45b7923cea01b5904f3cd3ddc989"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89e46ef59aad7beba174706b3aa93cf22b9b45b7923cea01b5904f3cd3ddc989"
    sha256 cellar: :any_skip_relocation, sonoma:        "bec5d743562605fceedb0f88a610771426273e886fd57e7045fcddac6a22b8fe"
    sha256 cellar: :any_skip_relocation, ventura:       "bec5d743562605fceedb0f88a610771426273e886fd57e7045fcddac6a22b8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e46ef59aad7beba174706b3aa93cf22b9b45b7923cea01b5904f3cd3ddc989"
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
