module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def custom_filter(filtering_params, member)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end