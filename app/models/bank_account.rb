class BankAccount < ApplicationRecord
    has_many :transactions
    # Its just to save us from sum every credit_transfer again to update the balance_cents
    attr_reader :last_amount_checked

    def has_enought_balance? credit_transfers
        # .is_currency is to base all amounts to EUR, so the sum is executed properly
        # Both .is_currency and .cents_to_eur are Numeric extention methods defined in config/initializers/numeric.rb

        @last_amount_checked = credit_transfers.sum(0) {|a| a[:amount].to_i.is_currency(a[:currency])}

        @last_amount_checked <= self.balance_cents.cents_to_eur
    end

    def process_credit_transfers credit_transfers
        Transaction.transaction do
            credit_transfers.each do |credit_transaction|
                amount_in_cents = credit_transaction[:amount].to_i.is_currency(credit_transaction[:currency]).eur_to_cents * -1

                self.transactions.create(
                    amount_cents: amount_in_cents,
                    amount_currency: credit_transaction[:currency],
                    counterparty_name: credit_transaction[:counterparty_name],
                    counterparty_bic: credit_transaction[:counterparty_bic],
                    counterparty_iban: credit_transaction[:counterparty_iban],
                    description: credit_transaction[:description]
                )
            end
        end
    end

end
