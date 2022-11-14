class ApplicationController < ActionController::Base
    # First we need to add session helper in application controller
    include SessionsHelper
    add_flash_types :info, :error, :warning
    def hello
        render html: "hello world"
    end
end
