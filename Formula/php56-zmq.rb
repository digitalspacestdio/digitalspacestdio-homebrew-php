require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php56Zmq < AbstractPhp56Extension
  init
  desc "ZeroMQ for PHP"
  homepage "http://php.zero.mq/"
  url "https://github.com/mkoppanen/php-zmq/archive/1.1.2.tar.gz"
  sha256 "2ae77e90e0ed8112b11e838d6303940bbcae39e8d37683632a299db881bdb217"
  head "https://github.com/mkoppanen/php-zmq.git"
  revision PHP_REVISION

  depends_on "pkg-config" => :build
  depends_on "zeromq"

  def install
    # ENV.universal_binary if build.universal?

    inreplace "package.xml", "@PACKAGE_VERSION@", version
    inreplace "php-zmq.spec", "@PACKAGE_VERSION@", version
    inreplace "php_zmq.h", "@PACKAGE_VERSION@", version

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/zmq.so"
    write_config_file if build.with? "config-file"
  end
end
