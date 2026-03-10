module SpreeTaxjar
  module Spree
    module CheckoutControllerDecorator
      def self.prepended(base)
        base.rescue_from Taxjar::Error::BadRequest, with: :taxjar_rollback
      end

      def taxjar_rollback(e)
        message = e.message&.gsub('to_zip', 'zip code')&.gsub('to_state', 'state')
        flash[:error] = message
        redirect_to spree.checkout_state_path(@order.state)
      end
    end

  end
end

::Spree::CheckoutController.prepend(::SpreeTaxjar::Spree::CheckoutControllerDecorator)
