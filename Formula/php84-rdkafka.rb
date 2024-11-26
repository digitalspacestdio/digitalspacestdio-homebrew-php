require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php84Rdkafka < AbstractPhp84Extension
  init
  desc "PHP extension for Apache Kafka (php-rdkafka)"
  homepage "https://github.com/arnaud-lb/php-rdkafka"
  url "https://pecl.php.net/get/rdkafka-6.0.3.tgz"
  sha256 "12eaab976d49697e31f1638b47889eb5ec61adb758708941112b157f8ec7dd48"
  head "https://github.com/arnaud-lb/php-rdkafka.git"
  revision PHP_REVISION

  bottle do
    root_url "https://pub-7d898cd296ae4a92a616d2e2c17cdb9e.r2.dev/php/8.4.1-106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c996011a3fa7db3df795b08e9c39bae82677a5c5bd107fcc24af6fe96d469f29"
    sha256 cellar: :any_skip_relocation, ventura:       "0e19b62d03d2ae8f95841ecfaa0e9b7007d490431f194d22453985b072d0ff2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d53ff689cd67927301e3ce0944f0a29fe93a6c8a738ee1a15cb40c71945a0e"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3812db1cca7e61f885747f773b73b0013e740479905aa412b45cb2814d4ca920"
  end

  depends_on "pcre2"

  resource "librdkafka" do
    url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.5.3.tar.gz"
    sha256 "eaa1213fdddf9c43e28834d9a832d9dd732377d35121e42f875966305f52b8ff"
  end

  def install
    resource("librdkafka").stage do
      ENV.append "CFLAGS", "-Wno-incompatible-pointer-types"
      ENV.append "CFLAGS", "-Wno-deprecated-declarations"
      args = []
      args << "--prefix=#{prefix}/librdkafka"
      args << "--mandir=#{man}"

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_prefix}/lib"
    ENV.append "CPPFLAGS", "-I#{Formula["pcre2"].opt_prefix}/include"

    Dir.chdir "rdkafka-#{version}" unless build.head?
    safe_phpize
    system "./configure", "--prefix=#{prefix}", "--with-rdkafka=#{prefix}/librdkafka", phpconfig
    system "make"
    prefix.install "modules/rdkafka.so"
    write_config_file if build.with? "config-file"
  end
end
