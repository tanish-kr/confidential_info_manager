# coding: utf-8

module ConfidentialInfoManager

  class JSON < Core

    ##
    # JSON file save
    # @param [Object] secret_data
    #   @note Object is a String or Array or Hash
    # @param [String] file_path
    def save(secret_data, file_path)
      File.open(file_path, "w") { |file| file.write(::JSON.pretty_generate(encrypt_only_value(secret_data))) }
    end

    ##
    # JSON file load
    # @param [String] file_path
    # @return [Hash]
    def load(file_path)
      decrypt_only_value(::JSON.parse(File.read(file_path), { symbolize_names: true }))
    end

  end

end
