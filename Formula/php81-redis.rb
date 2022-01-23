require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php81Redis < AbstractPhp81Extension
  init
  desc "PHP extension for Redis"
#   homepage "https://github.com/phpredis/phpredis"
#   url "https://github.com/phpredis/phpredis/archive/3.1.6.tar.gz"
#   sha256 "e0f00bd46f4790bf6e763762d9559d7175415e2f1ea1fcfea898bfb5298b43c4"
  url "https://github.com/phpredis/phpredis/archive/5.3.5.tar.gz"
  sha256 "88d8c7e93bfd9576fb5a51e28e8f9cc62e3515af5a3bca5486a76e70657213f2"
  version "5.3.5"
  head "https://github.com/phpredis/phpredis.git"

  depends_on "digitalspacestdio/php/php81-igbinary"
  depends_on "igbinary" => :build

  def install
    args = []
    args << "--enable-redis-igbinary"

    safe_phpize

    # Install symlink to igbinary headers inside memcached build directory
    (Pathname.pwd/"ext").install_symlink Formula["igbinary"].opt_include/"php7" => "igbinary"

    system "./configure", "--prefix=#{prefix}", phpconfig, *args
    system "make"

    prefix.install "modules/redis.so"

    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<~EOS

      ; phpredis can be used to store PHP sessions.
      ; To do this, uncomment and configure below
      ;session.save_handler = redis
      ;session.save_path = "tcp://host1:6379?weight=1, tcp://host2:6379?weight=2&timeout=2.5, tcp://host3:6379?weight=2"
    EOS
  end
end