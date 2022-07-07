# Things not implement
- Tests suite
# Adicional features
- Implemented a way to convert EUR to cents and vice versa
- Implemented a way to do Math with different currencies values(Still need to implement an API to return current currency rates), ex:
  - 1000.is_currency('JPY') + 20.is_currency('USD') = 26.85 # EUR
- Implemented a way to safeguard for concurrency requests for the same bank_account
- Implemented authentication via new column on bank_accounts table: api_token
# Files coded
- config/initializers/numeric_extensions.rb - Extended Numeric Class for converstions 
- app/controllers/api/v1/transactions_controller.rb - Service implementation
- app/models/bank_account.rb - Has the process logic to log transactions # Should be refactor into a BusinessLogic module
- app/models/transaction.rb
All files have short comments about my toughts on the Adicional features
# Solution description
At first glance my main concerns were
1. The concurrency requests for the same bank_account that could lead to unwanted transactions. This can happen in case a 2nd resquest comes in and validates the balance in the middle of 1st request validation and update/lock
2. A way to make proper comparison, sums, subtrations between different currencies.

For the point 1 possible solutions
- Lock the validation and the update of bank_account balance in an atomic transaction( This is implemented )
- Add a rule to column balance_cents to never be less than ZERO.
- Add a new column to say if its in process or not and lock the validations and update
- Implement a queue to process same client requests 1 at a time, but for that I cant render 422, should render 200, because the request was enqueed and later callback a service to answer with 201 or 422

For the point 2 solution
- I needed to find an API to get the current currency rates.
- I need a Class to be responsible for theses currency conversions that would use the above API (Did a quick search and read on money and money-rails gem)

# How to run
Shouldn't be difficult for a Rails developer since I am using the most recent ruby and rails versions, and not using any external gems.
Any Mac Os, Linux or Windows Subsystem Linux should run it
- Install ruby 3.1.2, eigher with a ruby version tool(rbenv, rvm) or in the system
- Install bundler gem `code(gem install bundler)`

```
git clone git@github.com:mpancada/BulkTransfers.git
```
```
cd BulkTransfers
```
```
git bundler install
```
```
rails s
```
