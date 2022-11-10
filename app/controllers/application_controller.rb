class ApplicationController < ActionController::Base
    add_flash_types :info, :error, :warning
    def hello
        render html: "hello world"
    end
end
