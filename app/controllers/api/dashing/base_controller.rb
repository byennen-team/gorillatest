class Api::Dashing::BaseController < ApplicationController

  http_basic_authenticate_with name: "autotest", password: "dashboard"
end
