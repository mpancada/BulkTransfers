class Api::V1::TransactionsController < ApplicationController
    before_action :require_valid_api_token

    def bulk_transfers
        # Need to lock, to make sure the balance validation and update are atomic
        # If not, another request may come in and see enought balance to start processing credit_transfers
        # ###
        # Could also be solved if the column balance_cents add a validations ensuring > 0, and check if update was successfull.
        # Could also be solved using a new column just to say if its already in process
        # Could also implement a queue to process same client requests 1 at a time, but for that I cant render 422, should render 200,
        # => because the request was enqueed and later callback a service to answer with 201 or 422
        @bank_account.with_lock do
            unless @bank_account.has_enought_balance?(params[:credit_transfers])
                render json: Api::V1::Response.new(nil, "Not enought balance"), status: 422 and return
            end

            @bank_account.update(balance_cents: (@bank_account.balance_cents - @bank_account.last_amount_checked.eur_to_cents))
        end

        # TODO do inside Begin/Rescue to "rollback" customer balance_cents in case there is 1 transfer that raises error
        # Or implement the "new column just to say if its already in process" soluction and update balance_cents at the end
        @bank_account.process_credit_transfers params[:credit_transfers]

        render json: Api::V1::Response.new(nil), status: 201
    end

    private

    def require_valid_api_token
        @bank_account = BankAccount.find_by(api_token: params[:api_token], iban: params[:organization_iban])
        return if @bank_account.present?

        render json: Api::V1::Response.new(nil, "Api key doest NOT match"), status: 401
    end

end

