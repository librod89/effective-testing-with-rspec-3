require 'sinatra/base'
require 'json'
require 'ox'
require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super
    end

    post '/expenses' do
      if request.media_type == 'text/xml'
        expense = Ox.load(request.body.string, mode: :hash)
      else
        expense = JSON.parse(request.body.read)
      end

      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      result = @ledger.expenses_on(params[:date])
      JSON.generate(result)
    end
  end
end
