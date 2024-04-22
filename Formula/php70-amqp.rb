require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Amqp < AbstractPhp70Extension
  init
  desc "PHP extension to communicate with any AMQP compliant server."
  homepage "https://github.com/php-amqp/php-amqp"
  url "https://github.com/php-amqp/php-amqp/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "b74de00674ee2f75a4c31f9af2475b9296d10d06549bdf605ca9d24c19510ca3"
  head "https://github.com/pdezwart/php-amqp.git"
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9814e9c03ba24a563e9a463ca5d78c9bf32d3d685eca906d32103e78d312656"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f45e0eda59812ccf8b6964428927771757577183dc36f12fc279de1ad45bf2"
    sha256 cellar: :any_skip_relocation, monterey:       "4748ef88f73c381db1fc9714c00bc345bac8f56684fd3c7ef4d111869605b088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9691f1f34e2700dbb545a28ba86df72403b7a3e9b6a537925c72ae228074323"
  end

  depends_on "rabbitmq-c"

  def install
    safe_phpize
    system "./configure", "--prefix=#{prefix}", "--with-amqp=#{Formula["rabbitmq-c"].opt_prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/amqp.so"
    write_config_file if build.with? "config-file"
  end
end
