require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php73Mongodb < AbstractPhp73Extension
  init PHP_VERSION, false
  desc "MongoDB driver for PHP."
  homepage "https://pecl.php.net/package/mongodb"
  url "https://github.com/mongodb/mongo-php-driver/releases/download/1.9.0/mongodb-1.9.0.tgz"
  sha256 "1a9e7117b749c2dd63bd3493bf38c24a9acd11646ec96a0d92ba6380eee0ab9a"
  head "https://github.com/mongodb/mongo-php-driver.git"
  version "1.9.0"
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd3d9bf50765afd4ae2b4c2d21c06924123efbb70cdc28c477637e7dea0537a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1588e36485805a0b17134df403ea59926ff18f6491c084d06668d904934bc054"
    sha256 cellar: :any_skip_relocation, sonoma:        "50931140dd7d03460e804d39c7d58c5efc0f5c6c452265c28cf420be8bd8120d"
    sha256 cellar: :any_skip_relocation, monterey:      "f3efe33eada6294a53edbd0d64885fd65e22f7885445a0f22b7490a3c2d96489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e5e73dc69e4f5fc52a8cd0663b0f160154c75e562bb3bd2714d236da0cc96ec"
  end

  depends_on "openssl"
  depends_on "digitalspacestdio/common/icu4c@69.1"

  def install
    Dir.chdir "mongodb-#{version}" unless build.head?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-mongodb-ssl=openssl --with-mongodb-icu=#{Formula["digitalspacestdio/common/icu4c@69.1"].opt_prefix} --with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make"
    prefix.install "modules/mongodb.so"
    write_config_file if build.with? "config-file"
  end
end
