# coding: utf-8

module ConfidentialInfoManager

  class YAML < Core

    ##
    # YAML file save
    # @param [Object] secret_data
    #   @note Object is a String or Array or Hash
    # @param [String] file_path
    def save(secret_data, file_path)
      File.open(file_path, "w") { |file| ::YAML.dump(encrypt_only_value(secret_data), file) }
    end

    ##
    # YAML file load
    # @param [String] file_path
    # @return [Hash]
    def load(file_path)
      decrypt_only_value(::YAML.load(File.read(file_path)))
    end

  end

end
