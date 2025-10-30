module SpreeTaxjar
  module Spree
    module ReimbursementDecorator
      def self.prepended(base)
        base.include Taxable

        # state_machine = base.state_machines[:reimbursement_status]
        # state_machine.after_transition to: [:reimbursed], do: :remove_tax_for_returned_items
      end

      def remove_tax_for_returned_items
        return unless ::Spree::Config[:taxjar_enabled]
        return unless taxjar_applicable?(order)
        client = ::Spree::Taxjar.new(order, self)
        client.create_refund_transaction_for_order
      end
    end
  end
end

Spree::Reimbursement.prepend(SpreeTaxjar::Spree::ReimbursementDecorator)