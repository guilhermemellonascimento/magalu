# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      # GET /api/v1/users
      def index
        users = UserQuery.new(filter_params).call
        render json: users, root: false
      end

      private

      def filter_params
        params.permit(:order_id, :start_date, :end_date, :page, :per_page)
      end
    end
  end
end
