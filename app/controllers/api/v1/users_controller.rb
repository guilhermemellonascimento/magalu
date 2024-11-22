# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = UserQuery.new(filter_params).call
        render json: users, root: false
      end

      private

      def filter_params
        params.permit(:id, :start_date, :end_date, :page, :per_page)
      end
    end
  end
end
